#ifndef _GPIO_
#define _GPIO_

class GPIOPin {
    public:
        GPIOPin(unsigned long Port, unsigned char Pin);
        GPIOPin(unsigned long Port, unsigned char Pin, unsigned long PinIO);
        GPIOPin(unsigned long Port, unsigned char Pin, unsigned long PinIO, unsigned char Val);
        void write(unsigned char Val);
        long read();
        void setDirMode(unsigned long PinIO);
        unsigned long dirMode();
        void setConfig(unsigned long Strengh, unsigned long PinType);
        void config(unsigned long *Strengh, unsigned long *PinType);
    private:
        unsigned char ucPin;
        unsigned long ulPort;
        unsigned long ulPinIO;
        unsigned char ucVal;
};


#endif
