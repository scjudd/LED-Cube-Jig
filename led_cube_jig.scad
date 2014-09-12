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
					cylinder(h=h, r=r+1.4);
					if (x < n-1)
						translate([0, -1.05])
							difference() {
								cube([l, 2.1, h]);
								translate([0, 0.7, -0.7]) cube([l, 0.7, h]);
							}
					if (y < n-1 && (x == 0 || x == n-1))
						translate([-1.05, 0])
							difference() {
								cube([2.1, l, h]);
								translate([0.7, 0, -0.7]) cube([0.7, l, h]);
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
		translate([1.05, y*l+(l/2)-2.5, 0]) {
			difference() {
				union() {
					cube([1.2, 5, h]);
					translate([1.2, 0])
						cube([3.8, 5, h+3]);
				}
				translate([0, 0.7, -0.7])
					cube([4.3, 3.6, h]);
				rotate(a=90, v=[1, 0, 0])
					translate([2.6, h+0.5, -6])
						union() {
							cube([1, 3, 7]);
							translate([0.5, 0]) cylinder(r=0.5, h=7);
						}
			}
		}
		translate([l*(n-1)-1.05, y*l+(l/2)+2.5, 0]) {
			rotate(180)
			difference() {
				union() {
					cube([1.2, 5, h]);
					translate([1.2, 0])
						cube([3.8, 5, h+3]);
				}
				translate([0, 0.7, -0.7])
					cube([4.3, 3.6, h]);
				rotate(a=90, v=[1, 0, 0])
					translate([2.6, h+0.5, -6])
						union() {
							cube([1, 3, 7]);
							translate([0.5, 0]) cylinder(r=0.5, h=7);
						}
			}
		}
	}
}

led_jig(4, 1.5, 17, 4);
