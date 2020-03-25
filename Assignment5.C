#include <stdio.h>
#include <dos.h>
#include <string.h>

int create_file(char near *filename)
{
   union REGS regs;
   int ret;
   regs.h.ah = 0x3C;
   regs.x.cx = 0;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);


   return(regs.x.cflag ? ret : 0);		
   /* if carry flag is set, there was an error */
}

int write_file(char near *filename, char near *str)
{
   union REGS regs;
   int ret;
   regs.x.cx = 0;
   regs.h.ah=0x3D;
   regs.h.al=2;
   regs.x.dx= (unsigned) filename;
   ret = intdos(&regs, &regs);   	//open file
   
   regs.x.bx=regs.x.ax;			//handle
   regs.x.cx=strlen(str);
   regs.h.ah = 0x40;
   regs.x.dx = (unsigned) str;
   ret = intdos(&regs, &regs);		//write

   regs.h.ah=0x3E;
   ret = intdos(&regs, &regs);   	//close file
   return(regs.x.cflag ? ret : 0);		
   /* if carry flag is set, there was an error */
}

int delete_file(char near *filename)
{
   union REGS regs;
   int ret;
   regs.h.ah = 0x41;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);

   return(regs.x.cflag ? ret : 0);					  
    /* if carry flag is set, there was an error */
}

int create_dir(char near *filename)
{
   union REGS regs;
   int ret;
   regs.h.ah = 0x39;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);

   return(regs.x.cflag ? ret : 0);					  
    /* if carry flag is set, there was an error */
}

int open_file(char near *filename)
{
   union REGS regs;
   int ret;
   regs.x.cx = 0;
   regs.h.ah=0x3D;
   regs.h.al=2;
   regs.x.dx= (unsigned) filename;
   ret = intdos(&regs, &regs);   	//open file

   return(regs.x.cflag ? ret : 0);					   
   /* if carry flag is set, there was an error */
}

int copy_file(char near *source, char near *dest)
{
   union REGS regs;
   struct SREGS sreg;
   int handle1;
   char* buffer;
   
   regs.x.cx = 0;
   regs.h.ah=0x3D;
   regs.h.al=2;
   regs.x.dx= (unsigned) source;
   intdos(&regs, &regs);   			//open  source file
   handle1=regs.x.ax;			//handle


   regs.x.bx=handle1;
   regs.h.ah=0x3F;
   regs.x.cx=0xFFFF;
   regs.x.dx=FP_OFF(buffer);
   sreg.ds=FP_SEG(buffer);
   intdosx(&regs,&regs,&sreg);
   
   regs.h.ah=0x3E;
   intdos(&regs, &regs);   			//close source file

   
   create_file(dest);
   open_file(dest);
   return(write_file(dest,buffer));
   
}






int main(void)
{
	int err,err1,choice;
	char name[100],str[100],namesource[100],namedest[100];
	do
	{
	printf("\n\nMENU\n\n(1)Create File\n(2)Delete File\n(3)Create Directry\n(4)Copy File\n(5)EXIT\n");
	printf("Enter Your Choice : ");
	scanf("%d",&choice);
	switch(choice)
	{
	case 1:
			printf("Enter Filename : ");
			scanf("%s", name);
			err=create_file(name);
			if(!err)
			{
				printf("File Created\n");
				printf("Enter data for the file : \n");
				gets(str);
				write_file(name,str);
			}
			else
				printf("Unable to create File\n");
			break;

	case 2:
		printf("Enter Filename : ");
		scanf("%s", name);
		err = delete_file(name);
		if (!err)
			printf("Able to delete ");
		else
			printf("Not Able to delete ");
		break;

	case 3:
		printf("Enter Filename : ");
		scanf("%s", name);
		err = create_dir(name);
		if (!err)
			printf("Directory Created\n");
		else
			printf("Unable to create Directory\n");
		break;

	case 4:
		printf("Enter Source filename: ");
		scanf("%s",namesource);
		printf("Enter Destination filename : ");
		scanf("%s",namedest);
		err=copy_file(namesource,namedest);
		if(!err)
		{
		   printf("\nCopy Successful ");
		}
		else
		{
		   printf("Copy Unsuccessful ");
		}
		break;  

	case 5:
		return 0;

	default:
		printf("INVALID CHOCIE !!!\n");
		break;
	}
	}while(1);
	return 0;
}












