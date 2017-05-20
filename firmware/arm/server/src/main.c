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
    POLLING,
    INTERRUPT
};

struct state {
    uWS::WebSocket<uWS::SERVER>* sock;
    bool sock_open;
    std::vector<unsigned short> data;
    size_t frameSize;
    size_t connections;
    enum modes mode;
    int fd;
};

int main(int argc, char* argv[]) {
    struct reg_instruction instruction;
    struct trg_instruction trg;
    uWS::Hub h;
    struct state s;
    s.sock_open = false;
    s.frameSize = 2000;
    s.connections = 0;
    s.mode = modes::POLLING;
    s.data.resize(s.frameSize);


    std::cout << "[Server started]" << std::endl;

    if(s.mode != modes::DEMO){

        std::cout << "Preparing logger ..." << std::endl;

        s.fd = open("/dev/logger0", O_RDWR);
        if(s.fd < 0){
            printf("Failed to open /dev/logger0 file!\n");
            return 1;
        }

        int fd = s.fd;

        // Count pre
        instruction.reg_id = 3;
        instruction.reg_value = s.frameSize / 2;
        ioctl(fd, WRITE_REG, &instruction);

        // Count suf
        instruction.reg_id = 4;
        instruction.reg_value = s.frameSize / 2;
        ioctl(fd, WRITE_REG, &instruction);

        // No test mode
        instruction.reg_id = 10;
        instruction.reg_value = 0;
        ioctl(fd, WRITE_REG, &instruction);

        // 2 channel
        instruction.reg_id = 5;
        instruction.reg_value = 2;
        ioctl(fd, WRITE_REG, &instruction);

        // Rising edge trigger
        trg.trg_id = 1;
        trg.trg_option = 4;
        trg.trg_slot_id = 0;
        trg.trg_value = 0x22;
        ioctl(fd, WRITE_TRG, &trg);

        trg.trg_id = 1;
        trg.trg_option = 4;
        trg.trg_slot_id = 1;
        trg.trg_value = 0x000036B3;
        ioctl(fd, WRITE_TRG, &trg);

        trg.trg_id = 1;
        trg.trg_option = 4;
        trg.trg_slot_id = 2;
        trg.trg_value = 2;
        ioctl(fd, WRITE_TRG, &trg);
        printf("Wrote triggers.\n");
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
            std::string str;
            str.append(message, length);
            std::cout << "[Message] " << str << std::endl;
            auto j = json::parse(str);

            // Change framesize if it was in the query
            if(j["frameSize"] != NULL){
                try {
                    s.frameSize = j["frameSize"].get<size_t>();
                    s.data.resize(s.frameSize);
                    std::cout << "Frame Size changed to " << j["frameSize"] << "." << std::endl;
                } catch(int e){
                    std::cout << "Failed to set Frame Size." << std::endl;
                }
            }
        }
    });

    h.onDisconnection([&s](uWS::WebSocket<uWS::SERVER> *ws, int code, char *message, size_t length) mutable {
        s.sock_open = false;
        std::cout << "[Connection lost] # clients: " << --s.connections << std::endl;
    });

    Timer *timer = new Timer(h.getLoop());
    timer->setData(&s);
    timer->start([](Timer *timer) {
        struct state* s = (struct state*)timer->getData();
        if(s->sock_open){
            // We just send a sine
            switch(s->mode){
                case modes::DEMO:{
                    for(size_t i = 0; i < s->frameSize; i++){
                        s->data[i] = (16384 + 7000 * sin((float)i/s->frameSize*40*M_PI));
                    } 
                    std::cout << "Send: " << s->data.size() << std::endl;
                    s->sock->send((char*)&s->data[0], s->data.size(), uWS::OpCode::BINARY);
                    break;
                }
                default:
                case modes::POLLING:{
                    int ret;
                    struct reg_instruction instruction;
                    // Count pre
                    instruction.reg_id = 3;
                    instruction.reg_value = s->frameSize / 2;
                    ioctl(s->fd, WRITE_REG, &instruction);

                    // Count suf
                    instruction.reg_id = 4;
                    instruction.reg_value = s->frameSize / 2;
                    ioctl(s->fd, WRITE_REG, &instruction);

                    ioctl(s->fd, START_REC, NULL);

                    struct data_instruction d_instruction;
                    d_instruction.resolution = 1;
                    d_instruction.channel = 1;
                    ioctl(s->fd, DATA_SETTINGS, &d_instruction);
                    // usleep(5 * 1000);
                    // ioctl(s->fd, STOP_REC, NULL);
                    lseek(s->fd, 0, SEEK_SET);
                    ret = read(s->fd, &s->data[0], s->frameSize);

                    printf("Read number of recorded samples ...\n");
                    instruction.reg_id = 11;
                    ioctl(s->fd, READ_REG, &instruction);
                    printf("Return value: %u\n", instruction.reg_value);
                    instruction.reg_id = 12;
                    ioctl(s->fd, READ_REG, &instruction);
                    printf("Return value: %u\n", instruction.reg_value);
                    printf("Checking error code ... ");
                    instruction.reg_id = 8;
                    ioctl(s->fd, READ_REG, &instruction);
                    printf("Return value: %u\n", instruction.reg_value);

                    printf("Checking faulty address ... ");
                    instruction.reg_id = 9;
                    ioctl(s->fd, READ_REG, &instruction);
                    printf("Return value: %u\n", instruction.reg_value);

                    if(ret < 0){
                        std::cout << "Read failed, consult kernel log." << std::endl;
                    }
                    else{
                        std::cout << "Read returned " << ret / 2 << " samples." << std::endl;
                    }
                    s->sock->send((char*)&s->data[0], s->data.size(), uWS::OpCode::BINARY);
                }
            }
        }
    }, 0, 35);

    h.listen(50090);
    h.run();
}