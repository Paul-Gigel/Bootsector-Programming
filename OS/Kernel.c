struct Video_Mem    {
    char* code;
    char* color;
};
void main() {
    struct Video_Mem videoMem = {(char*)0xb8000, (char*)0xb8001};
    *(Video_Mem.code) = 'Z';
	char* video_memory1 = (char*)0xb8002;
	*video_memory1 = 'A';
    char* video_memory2 = (char*)0xb8004;
    *video_memory2 = 'B';
}