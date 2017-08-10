#include <uWS.h>
#include <Node.h>
#include <iostream>
#include <cmath>
#include <vector>
#include "json.hpp"
#include <string>
#include "logger_types.h"
#include <sys/ioctl.h>
#include <thread>
#include <fstream>
#include <streambuf>
#include <sys/stat.h>

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
    size_t currentChannel;
    enum modes mode;
    int fd;
    bool configuring;
    bool reading;
};

bool hasEnding (std::string const &fullString, std::string const &ending) {
    if (fullString.length() >= ending.length()) {
        return (0 == fullString.compare (fullString.length() - ending.length(), ending.length(), ending));
    } else {
        return false;
    }
}

void readAndSendChannel(state* s){
    struct data_instruction d_instruction;
    d_instruction.resolution = 0;
    d_instruction.channel = s->currentChannel;
    ioctl(s->fd, DATA_SETTINGS, &d_instruction);

    size_t _read = 0;
    while(_read < s->frameSize * 2){
        size_t toRead = s->frameSize * 2 - _read;
        toRead = toRead < s->packetSize * 2 ? toRead : s->packetSize * 2;
        lseek(s->fd, _read, SEEK_SET);
        size_t ret = read(s->fd, &s->data[0], toRead);
        _read += ret;
        s->sock->send((char*)&s->data[0], ret, uWS::OpCode::BINARY);
    }
};

void waitForFrame(state* s){
    // Block until configuration was done (maybe there is a better way to do this)
    while(s->configuring || s->reading);
    s->reading = true;
    try {
        ioctl(s->fd, START_REC, NULL);
        std::cout << "Started a new Frame." << std::endl;
        std::cout << s->frameSize << " " << s->packetSize << " " << s->numberOfChannels << " " << s->data.size() << std::endl;

        readAndSendChannel(s);
        std::cout << "sent frame" << std::endl;
    } catch(int e){
        std::cout << "Failed to start a new Frame." << std::endl;
    }
    
    s->reading = false;
};

int main(int argc, char* argv[]) {
    uWS::Hub h;
    struct state s;
    s.sock_open = false;
    s.frameSize = 2048;
    s.packetSize = 2048;
    s.connections = 0;
    s.mode = modes::REAL;
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

        // Make sure the logger is not running, otherwise setting instructions will be ignored
        ioctl(s.fd, STOP_REC, NULL);

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
        std::string url;
        if(req.getUrl().toString() == "/"){
            url = std::string("/opt/server/webapp/index.html");
        } else {
            url = std::string("/opt/server/webapp") + req.getUrl().toString();
        }
        
        std::cout << "Got a HTTP request on: " << url << std::endl;

        std::ifstream stream(url);
        struct stat statbuf;
        stat(url.c_str(), &statbuf);

        if(stream.good()){//&& statbuf.st_mode == S_IFREG){
            std::string str((std::istreambuf_iterator<char>(stream)), std::istreambuf_iterator<char>());
            
            std::string mime;
            if(hasEnding(url, std::string(".css"))){
                mime = std::string("text/css");
            } else if(hasEnding(url, std::string(".js"))){
                mime = std::string("text/javascript");
            } else {
                mime = std::string("text/html");
            }
            char header[128];
            int header_length = std::sprintf(
                header,
                "HTTP/1.1 200 OK\r\nContent-Length: %u\r\nContent-Type: %s\r\n\r\n",
                str.size(),
                mime.c_str()
            );
            res->write(header, header_length);
            res->end(str.c_str(), str.size());
            std::cout << "File found!" << std::endl;
        } else {
            std::cout << "File " << url << " not found!" << std::endl;
            char header[128];
            int header_length = std::sprintf(header, "HTTP/1.1 404 Not Found\r\nContent-Length: %u\r\n\r\n", 0);
            res->write(header, header_length);
            res->end(nullptr, 0);
        }
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
            /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
             *
             * I M P O R T A N T : D E M O   M O D E   I S   DE P R E C A T E D
             *
             * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 
                if(!j["frameConfiguration"].is_null()){
                    std::cout << "Setting new Frame Configuration" << std::endl;
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        auto conf = j["frameConfiguration"];
                        if(!conf["frameSize"].is_null()){
                            s.frameSize = conf["frameSize"].get<size_t>();
                            std::cout << "New Frame Size is " << s.frameSize << std::endl;
                            if(!conf["packetSize"].is_null()){
                                s.packetSize = conf["packetSize"].get<size_t>();
                                std::cout << "New Packet Size is " << s.packetSize << std::endl;
                            } else {
                                s.packetSize = s.frameSize;
                                std::cout << "New Packet Size is " << s.frameSize << std::endl;
                            }
                            s.data.resize(s.packetSize);
                        }
                        if(!conf["pre"].is_null()){
                            // Ignore pre in demo mode
                        }
                        if(!conf["suf"].is_null()){
                            // Ignore suf in demo mode
                        }
                    } catch(int e){
                        std::cout << "Failed to set Frame Configuration." << std::endl;
                    }
                    s.configuring = false;
                }

                // Write a trigger into a pipeline
                if(!j["triggerOn"].is_null()){
                    std::cout << "Setting new Trigger" << std::endl;
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
                if(!j["setNumberOfChannels"].is_null()){
                    std::cout << "Setting number of Channels" << std::endl;
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        s.numberOfChannels = j["setNumberOfChannels"].get<size_t>();
                        std::cout << s.numberOfChannels << " will be transmitted." << std::endl;
                    } catch(int e){
                        std::cout << "Failed to select the channels." << std::endl;
                    }
                    s.configuring = false;
                }

                // Request a new frame of data
                if(!j["requestFrame"].is_null()){
                    std::cout << "Requesting Frame" << std::endl;
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    s.reading = true;
                    try {
                        ioctl(s.fd, START_REC, NULL);
                        std::cout << "Started a new Frame." << std::endl;
                        // Instantly generate a new sample
                        std::cout << s.frameSize << " " << s.packetSize << " " << s.numberOfChannels << " " << s.data.size() << std::endl;
                        // TODO: change to c=0 after testing!
                        for(size_t c = 1; c < s.numberOfChannels; c++){
                            size_t _read = 0;
                            while(_read < s.frameSize){
                                size_t toRead = s.frameSize - _read;
                                toRead = toRead < s.packetSize ? toRead : s.packetSize;
                                size_t i = 0;
                                for(; i < toRead; i++){
                                    s.data[i] = (8192 + 7000 * sin((float)(_read + i)/s.frameSize*40*M_PI + c * M_PI));
                                }
                                _read += i;
                                std::cout << s.data.size() << "/" << _read * 2 << std::endl;
                                s.sock->send((char*)&s.data[0], _read * 2, uWS::OpCode::BINARY);
                            }
                        }
                    } catch(int e){
                        std::cout << "Failed to start a new Frame." << std::endl;
                    }
                    s.reading = false;
                }

                // Force a trigger
                if(!j["forceTrigger"].is_null()){
                    std::cout << "Forcing Trigger" << std::endl;
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
                if(!j["frameConfiguration"].is_null()){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        auto conf = j["frameConfiguration"];
                        if(!conf["frameSize"].is_null()){
                            s.frameSize = conf["frameSize"].get<size_t>();
                            std::cout << "New Frame Size is " << s.frameSize << std::endl;
                            if(!conf["packetSize"].is_null()){
                                s.packetSize = conf["packetSize"].get<size_t>();
                                std::cout << "New Packet Size is " << s.packetSize << std::endl;
                            } else {
                                s.packetSize = s.frameSize;
                                std::cout << "New Packet Size is " << s.frameSize << std::endl;
                            }
                            s.data.resize(s.packetSize);
                        }
                        if(!conf["pre"].is_null()){
                            instruction.reg_id = 3;
                            instruction.reg_value = conf["pre"].get<size_t>();
                            ioctl(s.fd, WRITE_REG, &instruction);
                            std::cout << "New Pre is " << instruction.reg_value << std::endl;
                        }
                        if(!conf["suf"].is_null()){
                            instruction.reg_id = 4;
                            instruction.reg_value = conf["suf"].get<size_t>();
                            ioctl(s.fd, WRITE_REG, &instruction);
                            std::cout << "New Suf is " << instruction.reg_value << std::endl;
                        }
                    } catch(...){
                        std::cout << "Failed to set Frame Configuration." << std::endl;
                    }
                    s.configuring = false;
                }

                // Write a trigger into a pipeline
                if(!j["triggerOn"].is_null()){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        struct trg_instruction trg;
                        auto t = j["triggerOn"]; 
                        
                        if(t["type"] == "risingEdge" && !t["level"].is_null() && !t["channel"].is_null()){
                            size_t channel = t["channel"].get<size_t>();
                            std::cout << "Setting trigger for channel " << t["channel"] << std::endl;

                            // Set hysteresis
                            if(!t["hysteresis"].is_null()){
                                trg.trg_id = channel;
                                trg.trg_option = 4;
                                trg.trg_slot_id = 0;
                                trg.trg_value = (t["hysteresis"].get<size_t>() << 4) | 4 ;
                                ioctl(s.fd, WRITE_TRG, &trg);
                                std::cout << "Set a hysteresis of " << t["hysteresis"] << std::endl;    
                            }

                            // Determine slope
                            size_t slope = 0;
                            if(!t["slope"].is_null()){
                                slope = t["slope"].get<size_t>();
                            }

                            // Set trigger
                            trg.trg_id = channel;
                            trg.trg_option = 4;
                            trg.trg_slot_id = 1;
                            trg.trg_value = (slope << 20) | (t["level"].get<size_t>() << 4) | 3; 
                            ioctl(s.fd, WRITE_TRG, &trg);

                            // Set stop instruction
                            trg.trg_id = channel;
                            trg.trg_option = 4;
                            trg.trg_slot_id = 2;
                            trg.trg_value = 2;
                            ioctl(s.fd, WRITE_TRG, &trg);
                            
                            std::cout << "Wrote a Rising Edge Trigger at Level " << t["level"] << std::endl;
                        }
                    } catch(...){
                        std::cout << "Failed to write the Trigger." << std::endl;
                    }
                    s.configuring = false;
                }

                // Select the number of channels that is recorded and transmitted
                if(!j["setNumberOfChannels"].is_null()){
                    // Block until current frame was read (maybe there is a better way to do this)
                    while(s.reading);
                    s.configuring = true;
                    try {
                        s.numberOfChannels = j["setNumberOfChannels"].get<size_t>();
                        std::cout << s.numberOfChannels << " will be transmitted." << std::endl;
                    } catch(nlohmann::detail::type_error e){
                        std::cout << "Failed to select the channels." << std::endl;
                    }
                    s.configuring = false;
                }

                // Request a new frame of data
                if(!j["requestFrame"].is_null()){
                    // ussleep(30);
                    try {
                        s.currentChannel = j["channel"].get<size_t>();
                    } catch(nlohmann::detail::type_error e) {
                        std::cout << "No valid channel requested." << std::endl;
                    }
                    s.currentChannel = j["channel"].get<size_t>();
                    std::thread t1(waitForFrame, &s);
                    // TODO: do not detach but join
                    t1.detach();
                }

                // Request a new frame of data
                if(!j["readFrame"].is_null()){
                    // ussleep(30);
                    try {
                        s.currentChannel = j["channel"].get<size_t>();
                    } catch(nlohmann::detail::type_error e) {
                        std::cout << "No valid channel requested." << std::endl;
                    }
                    readAndSendChannel(&s);
                }

                // Force a trigger
                if(!j["forceTrigger"].is_null()){
                    // Block until configuration was done (maybe there is a better way to do this)
                    while(s.configuring);
                    try {
                        ioctl(s.fd, STOP_REC, NULL);
                        std::cout << "Forced a new Frame." << std::endl;
                    } catch(...){
                        std::cout << "Failed to force a new Frame." << std::endl;
                    }
                }

                // Request a new frame of data
                if(!j["samplingRate"].is_null()){
                    try {
                        auto samplingRate = j["samplingRate"].get<size_t>();
                        instruction.reg_id = 13;
                        auto match = true;
                        switch(samplingRate){
                            case 25000000:
                                instruction.reg_value = 5;
                                break;
                            case  5000000:
                                instruction.reg_value = 25;
                                break;
                            case  1000000:
                                instruction.reg_value = 125;
                                break;
                            case    200000:
                                instruction.reg_value = 625;
                                break;
                            case    100000:
                                instruction.reg_value = 1250;
                                break;
                            case     50000:
                                instruction.reg_value = 2500;
                                break;
                            default:
                                match = false;
                                break;
                            
                        }
                        if(match){
                            ioctl(s.fd, WRITE_REG, &instruction);
                            std::cout << "Sampling Rate is " << samplingRate << std::endl;
                        } else {
                            std::cout << samplingRate << " is no valid sampling rate." << std::endl;
                        }
                    } catch(nlohmann::detail::type_error e) {
                        std::cout << "No valid sampling rate requested." << std::endl;
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