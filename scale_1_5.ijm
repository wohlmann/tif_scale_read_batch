dir1 = getDirectory("Choose source directory ");
list = getFileList(dir1);
dir2 = getDirectory("Choose destination directory ");
Dialog.create("Analysis options");
Dialog.addChoice("batch mode?", newArray("use", "dont use"));
//Dialog.addCheckbox("use batch mode ", true);
Dialog.show;
batch1 = Dialog.getChoice();
batch=false;
	if(batch1=="use"){
		batch=true;
	}
run("Close All");
print("\\Clear");
print("Reset: log, Results, ROI Manager");
run("Clear Results");
updateResults;
roiManager("reset");
while (nImages>0) {
			selectImage(nImages);
			close();
}
if (batch==true){
	setBatchMode(true);
	print("_");
	print("running in batch mode");
}
N=0;
IMG=0;
nImg=0;
print("_");
for (i=0; i<list.length; i++) {
	path = dir1+list[i];
	print("start processing of "+path+"");
	print("_");
	//wait(300);
	run("Bio-Formats", "open=[path] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Set Scale...", "unit=micron");
	title = getTitle;
	width = getWidth;
	height = getHeight;
	depth = nSlices;
	getPixelSize(unit, pw, ph, pd);
	scale_x=pw;
	scale_y=ph;
	if (unit=="microns") {
		unt="µm";
	}
	print(title);
	print("scale_x= "+pw+"");
	print("scale_y= "+ph+"");
		setResult("filename", nResults, title);
		updateResults();
		setResult("scale_x", nResults-1, ""+scale_x+" "+unt+"");
		updateResults();
		setResult("scale_y", nResults-1, ""+scale_y+" "+unt+"");
		updateResults();
	while (nImages>0) {
			selectImage(nImages);
			close();
	N=N+1;
	}
}
print("_");
print("saving results");
print("_");
saveAs("Results", ""+dir2+"/Results.csv");
waitForUser("Summary",""+N+" images are measured. See Folder: "+dir2+"/Results.csv");
//Jens_02_06_2020