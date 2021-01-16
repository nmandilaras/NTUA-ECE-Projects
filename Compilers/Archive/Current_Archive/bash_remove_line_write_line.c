void move_line_after_line(FILE *f,where,after,char *adr){
	char *line[1500];
	char command[1500];
	/* get line */
	sprintf(command,"sed '%d!d' %s > temp.in",where,adr);
	system(command);
	/* line is stored in temp.in */
	/* delete line */
	sprintf(command,"sed -i '%dd' %s",where,adr);
	system(command);
	/* insert line after */
	sprintf(command,"sed '%di ' %s",where,adr);
	insert_line_after(f,line,after);
}


