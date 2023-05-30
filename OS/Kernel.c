//shit, I need to learn C syntax
struct Video_Mem    {
    char* code;
    char* color;
};
void main() {
    unsigned int i = 0;
    unsigned int foo = 0x0;
    struct Video_Mem videoMem[i];   //if I directly put value of i it gets very buggy
    for (unsigned int counter = 0; counter < i; counter++)   {
        videoMem[counter].code = (char*)(0xb8000 + foo);
        *videoMem[counter].code = 'X';
        foo += 2;
    }
}