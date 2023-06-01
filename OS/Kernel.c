#define BOOL int
extern void disable_paging(void);
extern int Cpuid_check(void);
extern BOOL Long_mode_capable(void);
struct Video_Mem    {
    char* code;
    char* color;
};
unsigned int print(char* string, unsigned int position)    {
    struct Video_Mem videoMem;
    for ( ; *string !=0; position +=2)   {
        videoMem.code = (char*)position;
        *(videoMem.code) = *string;
        string++;
    }
    return position;
}
void main() {
    char CPU_ID_SUPORTED[] = "CPU_ID SUPORTED";
    char CPU_ID_NOT_SUPORTED[] = "CPU_ID NOT SUPORTED";
    char LONG_MODE_CAPABLE[] = "LONG_MODE CAPABLE";
    char LONG_MODE_NOT_CAPABLE[] = "LONG_MODE NOT CAPABLE";
    int current_position = 0xb8000;
    disable_paging();
    if(Cpuid_check() == 2097152)    {
        current_position = print(CPU_ID_SUPORTED,current_position);
    };
    if(Cpuid_check() == 0)    {
        current_position = print(CPU_ID_NOT_SUPORTED,current_position);
    };
    if(Long_mode_capable() == 0)    {
        current_position = print(LONG_MODE_NOT_CAPABLE,current_position);
    };
    if(Long_mode_capable() == 1)    {
        current_position = print(LONG_MODE_CAPABLE,current_position);
    };
}