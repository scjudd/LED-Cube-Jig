/*
	n = number of LEDs (e.g, 4 -> 4x4 jig)
	r = radius of LED
	l = length of LED cathode leg (when bent)
	h = height of jig
*/

module led_jig(n, r, l, h) {
	// high resolution
	$fs = 0.01;

	// 1 mm LED leg overlap for soldering
	l = l-1;

	difference() {

		// base shape
		union() {
			for (x = [0:n-1]) for (y = [0:n-1]) {
				translate([x*l, y*l]) {
					cylinder(h=h, r=r+2);
					if (x < n-1)
						translate([0, -1.5])
							difference() {
								cube([l, 3, h]);
								translate([0, 1, -1]) cube([l, 1, h]);
							}
					if (y < n-1 && (x == 0 || x == n-1))
						translate([-1.5, 0])
							difference() {
								cube([3, l, h]);
								translate([1, 0, -1]) cube([1, l, h]);
							}
				}
			}
		}

		// punch out holes
		for (x = [0:n-1]) for (y = [0:n-1])
			translate([x*l, y*l, -1])
				cylinder(h=h+2, r=r);
	}

	// structural/ground wire scaffolding
	for (y = [0:n-2]) {
		translate([0.5, y*l+(l*0.5)-2.5, 0]) {
			difference() {
				difference() {
					translate([1, 0]) cube([5, 5, h+3]);
					translate([1, 1, -1]) cube([4, 3, h]);
				}
				translate([3.5, 6, h+0.5])
					rotate(a=90, v=[1,0,0]) {
						translate([-0.5, 0]) cube([1, 3, 7]);
						cylinder(h=7, r=0.5);
					}
			}
		}
		translate([l*(n-1)-7.5, y*l+(l*0.5)-2.5, 0]) {
			difference() {
				difference() {
					translate([1, 0]) cube([5, 5, h+3]);
					translate([2, 1, -1]) cube([4, 3, h]);
				}
				translate([3.5, 6, h+0.5])
					rotate(a=90, v=[1,0,0]) {
						translate([-0.5, 0]) cube([1, 3, 7]);
						cylinder(h=7, r=0.5);
					}
			}
		}
	}
}

led_jig(4, 1.5, 17, 4);
