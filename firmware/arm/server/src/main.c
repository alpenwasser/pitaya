#include <uWS.h>
#include <Node.h>
#include <iostream>
#include <cmath>
#include <vector>
#include "json.hpp"
#include <string>

using json = nlohmann::json;

struct state {
    uWS::WebSocket<uWS::SERVER>* sock;
    bool sock_open;
    std::vector<unsigned short> data;
    size_t frameSize;
    size_t connections;
};

int main() {
    uWS::Hub h;
    struct state s;
    s.sock_open = false;
    s.frameSize = 2000;
    s.connections = 0;
    s.data.resize(s.frameSize);

    std::cout << "Server started." << std::endl;

    h.onHttpRequest([](uWS::HttpResponse *res, uWS::HttpRequest req, char *data, size_t length, size_t remainingBytes) {
        res->end("KEKE", 4);
    });

    h.onConnection([&s](uWS::WebSocket<uWS::SERVER> *ws, uWS::HttpRequest req) mutable {
        s.sock = ws;
        s.sock_open = true;
        std::cout << "[New Connection] # clients: " << ++s.connections << std::endl;
    });

    h.onMessage([&s](uWS::WebSocket<uWS::SERVER> *ws, char *message, size_t length, uWS::OpCode opCode) {
        if(opCode == uWS::OpCode::TEXT){
            std::string str;
            str.append(message, length);
            std::cout << "Got message: " << str << std::endl;
            auto j = json::parse(str);
            if(j["frameSize"] != NULL){
                s.frameSize = j["frameSize"].get<size_t>();
                s.data.resize(s.frameSize);
            }
            std::cout << "FrameSize: " << j["frameSize"] << std::endl;
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
        for(size_t i = 0; i < s->frameSize; i++){
            s->data[i] = (16384 + 7000 * sin((float)i/s->frameSize*40*M_PI));
        }
        if(s->sock_open){
            std::cout << "Send: " << s->data.size() << std::endl;
            s->sock->send((char*)&s->data[0], s->data.size(), uWS::OpCode::BINARY);
        }
    }, 0, 350);

    h.listen(50090);
    h.run();
}