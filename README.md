# Lane_Detection

To implement this system for detecting longitudinal road markings, image processing techniques have been employed, as these markings exhibit simple linear shapes and are located in a known area of the image (for simple cases such as highways or stright roads).

The method consists of acquiring an RGB image, converting it from three color channels into a single grayscale format (since color information is not relevant in this case). With the grayscale image available, edge detection is performed using the Canny algorithm. Given that the mounting position of the image acquisition camera on the vehicle is known, the possible area where road markings may appear is also determined. Thus, a binary mask of a specific shape and size is created and applied over the previously obtained contours. This process helps extract a region of interest, which is then analyzed using the Hough Transform for straight-line detection. Based on certain criteria, such as the slope of the detected lines, inconclusive lines are eliminated, and only those corresponding to road markings are retained.

The system works fine on highway or straight roads images, but it is limited to detect only straight lines. A better version for a future project should be a perspective change such as eye bird view to be able to detect the curved lines (or other methods). 

There are 3 test videos uploaded which have been processed to show the detection results. All code is written in Matlab. There are personal implementation functions for Canny edge and Hough line detectors.
