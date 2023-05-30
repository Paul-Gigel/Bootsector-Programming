//shit, I need to learn C syntax
struct Video_Mem    {
    char* code;
    char* color;
};
void main() {
    //char padding[80] = {"01234567890123456789012345678901234567890123456789012345678901234567890123456789"};
    unsigned int i = 3;
    unsigned int foo = 0x0;
    struct Video_Mem videoMem[i];
    for (unsigned int counter = 0; counter < i; counter++)   {
        videoMem[counter].code = (char*)(0xb8000 + foo);
        *videoMem[counter].code = 'X';
        foo += 2;
    }
}