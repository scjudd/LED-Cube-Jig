/*
	n = number of LEDs (e.g, 4 -> 4x4 jig)
	d = diameter of LED
	l = length of LED leg (minus appropriate lengths for soldering)
*/

// High resolution
$fs = 0.01;

// Shapeways "Strong & Flexible Plastic" constraints
clearance = 0.5;
thickness = 0.7;

// Height of jig
height = 4;

// Length of ground wire supports
gws_length = 5;

module ground_wire_support() {
	difference() {
		union() {
			cube([1.2, gws_length, height]);
			translate([1.2, 0])
				cube([3.8, gws_length, height + 3]);
		}
		translate([-thickness, thickness, -thickness])
			cube([gws_length, 3.6, height]);
		rotate([90, 0, 0]) {
			translate([2.6, height + 0.5, -gws_length - clearance]) {
				union() {
					cube([1, 3, gws_length + 2 * clearance]);
					translate([0.5, 0])
						cylinder(r=0.5, h=(gws_length + 2 * clearance));
				}
			}
		}
	}
}

module led_socket(d) {
	r = d/2;
	difference() {
		cylinder(h=height, r=(r + 2 * thickness));
		translate([0, 0, -clearance])
			cylinder(h=(height + 2 * clearance), r=r);
	}
}

module led_socket_support(d, l) {
	r = d/2;
	translate([0, -1.5 * thickness]) {
		difference() {
			cube([l, 3 * thickness, height]);
			translate([0, 1.5 * thickness, -clearance])
				cylinder(h=(height + 2 * clearance), r=(r + 2 * thickness));
			translate([l, 1.5 * thickness, -clearance])
				cylinder(h=(height + 2 * clearance), r=(r + 2 * thickness));
			translate([0, thickness, -thickness])
				cube([l, thickness, height]);
		}
	}
}

module horizontal_jig(n, d, l) {
	r = d/2;
	translate([-(n-1)/2*l, -(n-1)/2*l, 0]) {
		for (x = [0:n-1]) for (y = [0:n-1]) {
			translate([x*l, y*l]) {
				led_socket(d);
				if (x < n-1)
					led_socket_support(d, l);
				if (y < n-1 && (x == 0 || x == n-1)) {
					rotate(90)
						led_socket_support(d, l);
					rotate(x == 0 ? 0 : 180) {
						translate([1.5 * thickness, (x == 0 ? l : -l)/2-gws_length/2]) {
							translate([-6 * thickness, 0, 0]) {
								difference() {
									translate([-thickness, -thickness])
										cube([4 * thickness, gws_length + 2 * thickness, height]);
									translate([0, 0, -clearance])
										cube([3 * thickness, gws_length, height + 2 * clearance]);
								}
							}
							ground_wire_support();
						}
					}
				}
			}
		}
	}
}

module vertical_ground_wire_support(n, l) {
	difference() {
		cube([3 * thickness, gws_length, l * (n - 1) + height + 3]);
		translate([thickness, thickness, -clearance])
			cube([thickness, gws_length - 2 * thickness, l * (n - 1) + height + 3 + 2 * clearance]);
	}
	for (z = [1: n-1]) {
		translate([3 * thickness, 0, z*l]) {
			difference() {
				translate([0, 0, 3 - thickness])
					cube([5 + 3 * thickness, gws_length, height + thickness]);
				translate([-0, thickness, 3 - 2 * thickness])
					cube([4 * thickness + clearance, gws_length - 2 * thickness, height + thickness]);
				rotate([90, 0, 0]) {
					translate([3 * thickness + 2.6, height + 0.5, -gws_length - clearance]) {
						union() {
							cube([1, 3, gws_length + 2 * clearance]);
							translate([0.5, 0])
								cylinder(r=0.5, h=(gws_length + 2 * clearance));
						}
					}
				}
			}
		}
	}
}

/*
	n  = cube dimension
	al = anode length
	cl = cathode length
*/
module vertical_jig(n, al, cl) {
	translate([-1.5 * cl - 4.5 * thickness, cl-gws_length/2])
		vertical_ground_wire_support(n, al);
	translate([-1.5 * cl - 4.5 * thickness, -cl-gws_length/2])
		vertical_ground_wire_support(n, al);
	rotate(180) translate([-1.5 * cl - 4.5 * thickness, cl-gws_length/2])
		vertical_ground_wire_support(n, al);
	rotate(180) translate([-1.5 * cl - 4.5 * thickness, -cl-gws_length/2])
		vertical_ground_wire_support(n, al);
}

module vertical_jig_separated(n, al, cl) {
	translate([0, 0, gws_length]) {
		translate([-2 * cl, 1.75 * cl])
			rotate([90, 180, 0])
				vertical_ground_wire_support(n, al);
		translate([-1.75 * cl, -2 * cl])
			rotate([90, 180, 90])
				vertical_ground_wire_support(n, al);
		rotate(180) translate([-2 * cl, 1.75 * cl])
			rotate([90, 180, 0])
				vertical_ground_wire_support(n, al);
		rotate(180) translate([-1.75 * cl, -2 * cl])
			rotate([90, 180, 90])
				vertical_ground_wire_support(n, al);
	}
}

horizontal_jig(4, 3, 16);
vertical_jig_separated(4, 16, 16);
