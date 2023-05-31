extern int Cpuid_check(void);
struct Video_Mem    {
    char* code;
    char* color;
};
unsigned int print(char* string, unsigned int last_position)    {
    for (unsigned int position = last_position+1; *string !='0'; position +=2)   {
        struct Video_Mem videoMem = {position,0};
        *(videoMem.code) =
    }
}
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
    Cpuid_check();
}