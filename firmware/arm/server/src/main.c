#include <uWS.h>
#include <Node.h>
#include <iostream>
#include <cmath>
#include <vector>
#include "json.hpp"
#include <string>
#include "logger_types.h"
#include <sys/ioctl.h>

#define MAGIC_NUMBER 42
#define DATA_SETTINGS _IOWR(MAGIC_NUMBER, 0, void*)
#define WRITE_REG _IOWR(MAGIC_NUMBER, 1, void*)
#define READ_REG _IOWR(MAGIC_NUMBER, 2, void*)
#define WRITE_TRG _IOWR(MAGIC_NUMBER, 3, void*)
#define START_REC _IOWR(MAGIC_NUMBER, 4, void*)
#define STOP_REC _IOWR(MAGIC_NUMBER, 5, void*)

using json = nlohmann::json;

enum modes {
    DEMO,
    REAL
};

struct state {
    uWS::WebSocket<uWS::SERVER>* sock;
    bool sock_open;
    std::vector<unsigned short> data;
    size_t frameSize;
    size_t packetSize;
    size_t numberOfChannels;
    size_t connections;
    enum modes mode;
    int fd;
    bool configuring;
    bool reading;
};

int main(int argc, char* argv[]) {
    uWS::Hub h;
    struct state s;
    s.sock_open = false;
    s.frameSize = 2048;
    s.packetSize = 2048;
    s.connections = 0;
    s.mode = modes::DEMO;
    s.data.resize(s.frameSize);
    s.configuring = 0;
    s.reading = 0;


    std::cout << "[Server started]" << std::endl;

    if(s.mode != modes::DEMO){

        std::cout << "Preparing logger ..." << std::endl;

        // open the logger file and remember it
        s.fd = open("/dev/logger0", O_RDWR);
        if(s.fd < 0){
            printf("Failed to open /dev/logger0 file!\n");
            return 1;
        }

        // Make sure test mode is not on
        struct reg_instruction instruction;
        instruction.reg_id = 10;
        instruction.reg_value = 0;
        ioctl(s.fd, WRITE_REG, &instruction);

        // Set number of channels to two
        instruction.reg_id = 5;
        instruction.reg_value = 2;
        ioctl(s.fd, WRITE_REG, &instruction);

        std::cout << "Initialized logger." << std::endl;
    }

    h.onHttpRequest([](uWS::HttpResponse *res, uWS::HttpRequest req, char *data, size_t length, size_t remainingBytes) {
        res->end("KEKE", 4);
    });

    h.onConnection([&s](uWS::WebSocket<uWS::SERVER> *ws, uWS::HttpRequest req) mutable {
        if(s.sock_open){
            s.sock->close();
        }
        s.sock = ws;
        s.sock_open = true;
        std::cout << "[New Connection] # clients: " << ++s.connections << std::endl;
    });

    h.onMessage([&s](uWS::WebSocket<uWS::SERVER> *ws, char *message, size_t length, uWS::OpCode opCode) {
        // Only react to textmessages
        if(opCode == uWS::OpCode::TEXT){
            struct reg_instruction instruction;
            // Parse the JSON query that was received
            std::string str;
            str.append(message, length);
            std::cout << "[Message] " << str << std::endl;
            auto j = json::parse(str);

            switch(s.mode){
            case modes::DEMO:
                if(j["frameConfiguration"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        auto conf = j["frameConfiguration"];
                        if(conf["frameSize"] != NULL){
                            s.frameSize = conf["frameSize"].get<size_t>();
                            std::cout << "New Frame Size is " << s.frameSize << std::endl;
                            if(conf["packetSize"] != NULL){
                                s.packetSize = conf["packetSize"].get<size_t>();
                                std::cout << "New Packet Size is " << s.packetSize << std::endl;
                            } else {
                                s.packetSize = s.frameSize;
                                std::cout << "New Packet Size is " << s.frameSize << std::endl;
                            }
                        }
                        if(conf["pre"] != NULL){
                            // Ignore pre in demo mode
                        }
                        if(conf["suf"] != NULL){
                            // Ignore suf in demo mode
                        }
                    } catch(int e){
                        std::cout << "Failed to set Frame Configuration." << std::endl;
                    }
                    s.configuring = false;
                }

                // Write a trigger into a pipeline
                if(j["triggerOn"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        // Don't configure any trigger   
                        std::cout << "Wrote a Rising Edge Trigger" << std::endl;
                    } catch(int e){
                        std::cout << "Failed to write the Trigger." << std::endl;
                    }
                    s.configuring = false;
                }

                // Select the number of channels that is recorded and transmitted
                if(j["selectChannels"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        s.numberOfChannels = j["selectChannels"].get<size_t>();
                        std::cout << s.numberOfChannels << " will be transmitted." << std::endl;
                    } catch(int e){
                        std::cout << "Failed to select the channels." << std::endl;
                    }
                    s.configuring = false;
                }

                // Request a new frame of data
                if(j["requestFrame"] != NULL){
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    s.reading = true;
                    try {
                        ioctl(s.fd, START_REC, NULL);
                        std::cout << "Started a new Frame." << std::endl;
                        // Instantly generate a new sample
                        size_t _read = 0;
                        while(_read < s.frameSize){
                            size_t toRead = s.frameSize - _read;
                            toRead = toRead < s.packetSize ? toRead : s.packetSize;
                            size_t i = 0;
                            for(; i < toRead; i++){
                                s.data[i] = (8192 + 7000 * sin((float)(_read + i)/s.frameSize*40*M_PI));
                            }
                            _read += i;
                            s.sock->send((char*)&s.data[0], _read * 2, uWS::OpCode::BINARY);
                        }
                    } catch(int e){
                        std::cout << "Failed to start a new Frame." << std::endl;
                    }
                    s.reading = false;
                }

                // Force a trigger
                if(j["forceTrigger"] != NULL){
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    try {
                        // We don't actually do stuf in demo mode since requestFrame will instantly return
                        std::cout << "Forced a new Frame." << std::endl;
                    } catch(int e){
                        std::cout << "Failed to force a new Frame." << std::endl;
                    }
                }
                break;
            case modes::REAL:
                // Changes the configuration of a frame
                // frame size, pre/suf count, packetSize
                if(j["frameConfiguration"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        auto conf = j["frameConfiguration"];
                        if(conf["frameSize"] != NULL){
                            s.frameSize = conf["frameSize"].get<size_t>();
                            std::cout << "New Frame Size is " << s.frameSize << std::endl;
                            if(conf["packetSize"] != NULL){
                                s.packetSize = conf["packetSize"].get<size_t>();
                                std::cout << "New Packet Size is " << s.packetSize << std::endl;
                            } else {
                                s.packetSize = s.frameSize;
                                std::cout << "New Packet Size is " << s.frameSize << std::endl;
                            }
                        }
                        if(conf["pre"] != NULL){
                            instruction.reg_id = 3;
                            instruction.reg_value = conf["pre"];
                            ioctl(s.fd, WRITE_REG, &instruction);
                            std::cout << "New Pre is " << instruction.reg_value << std::endl;
                        }
                        if(conf["suf"] != NULL){
                            instruction.reg_id = 4;
                            instruction.reg_value = conf["suf"];
                            ioctl(s.fd, WRITE_REG, &instruction);
                            std::cout << "New Suf is " << instruction.reg_value << std::endl;
                        }
                    } catch(int e){
                        std::cout << "Failed to set Frame Configuration." << std::endl;
                    }
                    s.configuring = false;
                }

                // Write a trigger into a pipeline
                if(j["triggerOn"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        struct trg_instruction trg;
                        auto t = j["triggerOn"]; 
                        
                        if(t["type"] == "risingEdge" && t["level"] != NULL && t["channel"] != NULL){
                            size_t channel = t["channel"].get<size_t>();
                            std::cout << "Setting trigger for channel " << t["channel"] << std::endl;

                            // Set hysteresis
                            if(t["hysteresis"] != NULL){
                                trg.trg_id = channel;
                                trg.trg_option = 4;
                                trg.trg_slot_id = 0;
                                trg.trg_value = (t["hysteresis"].get<size_t>() << 4) & 4 ;
                                ioctl(s.fd, WRITE_TRG, &trg);
                                std::cout << "Set a hysteresis of " << t["hysteresis"] << std::endl;    
                            }

                            // Determine slope
                            size_t slope = 0;
                            if(t["slope"] != NULL){
                                slope = t["slope"].get<size_t>();
                            }

                            // Set trigger
                            trg.trg_id = channel;
                            trg.trg_option = 4;
                            trg.trg_slot_id = 1;
                            trg.trg_value = (slope << 20) & (t["level"].get<size_t>() << 4) & 3; 
                            ioctl(s.fd, WRITE_TRG, &trg);

                            // Set stop instruction
                            trg.trg_id = 1;
                            trg.trg_option = 4;
                            trg.trg_slot_id = 2;
                            trg.trg_value = 2;
                            ioctl(s.fd, WRITE_TRG, &trg);
                            
                            std::cout << "Wrote a Rising Edge Trigger at Level " << t["level"] << std::endl;
                        }
                    } catch(int e){
                        std::cout << "Failed to write the Trigger." << std::endl;
                    }
                    s.configuring = false;
                }

                // Select the number of channels that is recorded and transmitted
                if(j["selectChannels"] != NULL){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        instruction.reg_id = 5;
                        instruction.reg_value = j["selectChannels"].get<size_t>() & ~1;
                        ioctl(s.fd, WRITE_REG, &instruction);
                        s.numberOfChannels = j["selectChannels"].get<size_t>();
                        std::cout << "Logger now has " << instruction.reg_value << "Channels. " << s.numberOfChannels << " will be transmitted." << std::endl;
                    } catch(int e){
                        std::cout << "Failed to select the channels." << std::endl;
                    }
                    s.configuring = false;
                }

                // Request a new frame of data
                if(j["requestFrame"] != NULL){
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    s.reading = true;
                    try {
                        ioctl(s.fd, START_REC, NULL);
                        std::cout << "Started a new Frame." << std::endl;
                        size_t _read = 0;
                        while(_read < s.frameSize * 2){
                            size_t toRead = s.frameSize * 2 - _read;
                            toRead = toRead < s.packetSize * 2 ? toRead : s.packetSize * 2;
                            lseek(s.fd, _read, SEEK_SET);
                            size_t ret = read(s.fd, &s.data[0], toRead);
                            _read += ret;
                            s.sock->send((char*)&s.data[0], ret, uWS::OpCode::BINARY);
                        }
                    } catch(int e){
                        std::cout << "Failed to start a new Frame." << std::endl;
                    }
                    s.reading = false;
                }

                // Force a trigger
                if(j["forceTrigger"] != NULL){
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    try {
                        ioctl(s.fd, STOP_REC, NULL);
                        std::cout << "Forced a new Frame." << std::endl;
                    } catch(int e){
                        std::cout << "Failed to force a new Frame." << std::endl;
                    }
                }
                break;
            default:
                // Do nothing if mode somehow is not set (should never happen)
                break;
            }
        }
    });

    h.onDisconnection([&s](uWS::WebSocket<uWS::SERVER> *ws, int code, char *message, size_t length) mutable {
        s.sock_open = false;
        std::cout << "[Connection lost] # clients: " << --s.connections << std::endl;
    });

    h.listen(50090);
    h.run();
}