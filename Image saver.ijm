//-----------------------------Dark frames-----------------------------
channel_d = newArray(4);
channel_d[0] = 0;
channel_d[1] = 6;
channel_d[2] = 0;
channel_d[3] = 0;
//---------------------------------------------------------------------

//-----------------------------Channel colors--------------------------
color = newArray(4);
color[0] = "Cyan";
color[1] = "Red";
color[2] = "Blue";
color[3] = "Green";
//---------------------------------------------------------------------

//-----------------Frames to save--------------------------------------
arr = newArray (1,8,15,30);
//-----------------Parameters------------------------------------------

crop = false;

arrange = true;

arrange_vertical = false;
arrange_horisontal = true;
//---------------------------------------------------------------------

//------------------Arrangement parameters-----------------------------

mode_1 = true;  //image merge + crop full
mode_2 = false; //image full + crop merge
mode_3 = false; //image full + crop full
mode_4 = false; //image merge + crop merge
//---------------------------------------------------------------------



flag = true;

if (arr.length == 0){
	flag = arr.length;
	arr = newArray(1);
	arr[0] = flag;
	flag = false;
}

if (arr[0] == 0 && flag == true){
	flag = arr.length;
	arr = newArray(1);
	arr[0] = flag;
}

//Array.show(arr);

Stack.getDimensions(width, height, channels, slices, frames);


dir = getDirectory("Choose directory");
dir1 = dir + " Full image\\";
File.makeDirectory(dir1);

rename("raw_data");

if (crop == true){
	selectWindow("raw_data");
	waitForUser("Select rectangular area");

	run("Duplicate...", "title=raw_data_croped duplicate");
	selectWindow("raw_data_croped");
	dir2 = dir + " Croped image\\";
	File.makeDirectory(dir2);
	selectWindow("raw_data");
	run("Select None");
}



setBatchMode(true);
for (i=0; i<arr.length; i++){

	selectWindow("raw_data");
	index = arr[i];

	
	run("Duplicate...", "duplicate frames=index-index");
	rename ("raw_data_frame");
	
	selectWindow("raw_data_frame");
	run("Split Channels");

	for (j = 0; j<channels; j++){
		name = "C" + j+1 + "-raw_data_frame";
		selectWindow(name);
		if (channel_d[j] < index)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
		run(color[j]);
	}
	
	merge_line="";
	for (j = 0; j<channels; j++){
		merge_line+= "c" + j+1 +"=C" + j+1 + "-raw_data_frame "; 
	}
	merge_line+= "create keep";

	run("Merge Channels...", merge_line);
	rename("merged_full");
	run("RGB Color");
		name = dir1 + File.separator + arr[i] + "_frame_merged.jpg"; 
		saveAs("Jpeg", name);
		close();
		selectWindow ("merged_full");
		close();
	
	for (j = 0; j<channels; j++){
		name = "C" + j+1 + "-raw_data_frame";
		
		selectWindow(name);
		//run("Enhance Contrast", "saturated=0.35");

		selectWindow(name);
		run(color[j]);
		run("RGB Color");
		name = dir1 + File.separator + arr[i] + "_frame_" + color[j] + ".jpg"; 
		saveAs("Jpeg", name);
		close();
	}

	if(crop == true){

	selectWindow("raw_data_croped");
	index = arr[i];
	run("Duplicate...", "duplicate frames=index-index");
	rename ("raw_data_frame");
	
	selectWindow("raw_data_frame");
	run("Split Channels");

	for (j = 0; j<channels; j++){
		name = "C" + j+1 + "-raw_data_frame";
		selectWindow(name);
		if (channel_d[j] < index)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
		run(color[j]);
	}
	
	merge_line="";
	for (j = 0; j<channels; j++){
		merge_line+= "c" + j+1 +"=C" + j+1 + "-raw_data_frame "; 
	}
	merge_line+= "create keep";

	run("Merge Channels...", merge_line);
	rename("merged_full");
	run("RGB Color");
		name = dir2 + File.separator + arr[i] + "_frame_merged.jpg"; 
		saveAs("Jpeg", name);
		close();
		selectWindow ("merged_full");
		close();
	
	for (j = 0; j<channels; j++){
		name = "C" + j+1 + "-raw_data_frame";
		
		selectWindow(name);
		//run("Enhance Contrast", "saturated=0.35");

		selectWindow(name);
		run(color[j]);
		run("RGB Color");
		name = dir2 + File.separator + arr[i] + "_frame_" + color[j] + ".jpg"; 
		saveAs("Jpeg", name);
		close();
	}
}
}


//--------------------------------------------------------------------------------------------------
//-----------------------------------Arrange--------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//setBatchMode(false);

if (arrange == true){

	stripe1 = width/20 - width%20;
	stripe2 = stripe1 * 2;

	//------------No crop horisontal-------------------------------------------------
	if (crop == false && arrange_horisontal == true){

	

		for (j=0; j<channels; j++){			
			for(i=0; i<arr.length; i++){
				name = dir1 + File.separator + arr[i] + "_frame_" + color[j] + ".jpg";
				open(name);
				rename("Frame");
				if(i == arr.length-1){
					rename("Arranged_1");
					run("Combine...", "stack1=Arranged stack2=Arranged_1");
				}
				if (i>0 && i < arr.length-1) {
					newImage("spacer", "RGB white", stripe1, width, 1);
					run("Combine...", "stack1=Frame stack2=spacer");
					rename("Arranged_1");
					run("Combine...", "stack1=Arranged stack2=Arranged_1");
				}
				if (i == 0) {
					newImage("spacer", "RGB white", stripe1, width, 1);
					run("Combine...", "stack1=Frame stack2=spacer");
				}
				rename("Arranged");
			}
			name = "Line_" + j;
			rename(name);
		}	

		for(i=0; i<arr.length; i++){
				name = dir1 + File.separator + arr[i] + "_frame_merged.jpg";
				open(name);
				rename("Frame");
				if(i == arr.length-1){
					rename("Arranged_1");
					run("Combine...", "stack1=Arranged stack2=Arranged_1");
				}
				if (i>0 && i < arr.length-1) {
					newImage("spacer", "RGB white", stripe1, height, 1);
					run("Combine...", "stack1=Frame stack2=spacer");
					rename("Arranged_1");
					run("Combine...", "stack1=Arranged stack2=Arranged_1");
				}
				if (i == 0) {
					newImage("spacer", "RGB white", stripe1, height, 1);
					run("Combine...", "stack1=Frame stack2=spacer");
				}
				rename("Arranged");
			}
			name = "Line_merge";
			rename(name);
			
		Stack.getDimensions(width, height, channels1, slices1, frames1);
		
		for (j=0; j<channels; j++){
			if(j == 0){
				name = "Line_" + j;
				selectWindow(name);
				rename("Frame");
				newImage("spacer", "RGB white", width, stripe1, 1);
				run("Combine...", "stack1=Frame stack2=spacer combine");
				rename("Arranged");
			}

			if(j > 0 && j<channels){
				name = "Line_" + j;
				selectWindow(name);
				rename("Frame");
				newImage("spacer", "RGB white", width, stripe1, 1);
				run("Combine...", "stack1=Frame stack2=spacer combine");
				rename("Arranged1");
				run("Combine...", "stack1=Arranged stack2=Arranged1 combine");
			}

			
			rename("Arranged");
		}

		run("Combine...", "stack1=Arranged stack2=Line_merge combine");
		setBatchMode(false);
		rename("Arranged");
		
		
	}

	//-------------------------------------------------------------------------------

	//------------No crop vertical---------------------------------------------------
	if (crop == false && arrange_vertical == true){
		
	}

	//-------------------------------------------------------------------------------
	
	
	//-------------Image merge + full crop horisontal--------------------------------
	if (mode_1 == true && arrange_horisontal == true){
		
	}
}


