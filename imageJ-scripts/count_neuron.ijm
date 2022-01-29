close("*");
setBatchMode("hide");
input = "/Volumes/4TB/96WP/96WP_Data/C2";
output = "/Users/samuelorion/Documents/GitHub/2020_Manuscript/R/DATA-OUT/96WP/NEURON/";
File.makeDirectory(output);
images_to_open = getFileList(input); 

for (i = 704; i < images_to_open.length; i++){


	
	file = input + "/" + images_to_open[i];
	t = getTime();
	image_name = replace(images_to_open[i],".tif","");
	print(image_name);  
	//run("Bio-Formats", "open=file autoscale color_mode=Default crop rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT x_coordinate_1=5000 y_coordinate_1=5000 width_1=8000 height_1=8000");
	open(file);
	run("mpl-viridis");
	run("Enhance Contrast", "saturated=0.35");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	//run("Duplicate...", " ");
	image = getTitle();	
	run("Duplicate...", " ");
	image_duplicate = getTitle();
	run("Gaussian Blur...", "sigma=20");
	imageCalculator("Subtract", image,image_duplicate);
	//run("Subtract...", "value=100");
	setMinAndMax(100, 2000);
	selectWindow(image_duplicate); close();
	selectWindow(image);
	run("Gaussian Blur...", "sigma=10");
	setThreshold(1200, 65535);
	run("Convert to Mask");
	run("Set Measurements...", "area centroid redirect=None decimal=0");
	run("Analyze Particles...", "size=15-1000 show=Nothing display");
	saveAs("Results", output + image_name + "_sep_neuron.csv");
	run("Clear Results"); run("Close");
	close("*");
	t2 = getTime();
	time_taken = (t2-t)/1000;
	print(time_taken + " seconds");
}
	