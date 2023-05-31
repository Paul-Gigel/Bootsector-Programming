extern int Cpuid_check(void);
struct Video_Mem    {
    char* code;
    char* color;
};
unsigned int print(char* string, unsigned int last_position)    {
    struct Video_Mem videoMem;
    for (unsigned int position = last_position; *string !=0; position +=2)   {
        videoMem.code = (char*)position;
        *(videoMem.code) = *string;
        string++;
    }
}
void main() {
    char CPU_ID_SUPORTED[] = "CPU_ID SUPORTED";
    char CPU_ID_NOT_SUPORTED[] = "CPU_ID NOT SUPORTED";
    char* lel = (char*)0xb8000;
    *lel = (Cpuid_check()<<1)+'0';
    if(Cpuid_check() == 1)    {
        print(CPU_ID_SUPORTED,0xb8000);
    };
    if(Cpuid_check() == 0)    {
        print(CPU_ID_NOT_SUPORTED,0xb8000);
    };
}