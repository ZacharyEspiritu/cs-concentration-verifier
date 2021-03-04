abstract sig Course {}
one sig APMA1650, APMA1655, 
CSCI0020, CSCI0030, CSCI0040, CSCI0050, CSCI0060, CSCI0080, 
CSCI0090A, CSCI0090B, CSCI0090C, CSCI0100, CSCI0111, 
CSCI0112, CSCI0130, CSCI0150, CSCI0160, CSCI0170, CSCI0180,
CSCI0190, CSCI0220, CSCI0300, CSCI0310, CSCI0320, CSCI0330,
CSCI0360, CSCI0450, CSCI0510, CSCI0530, CSCI0920, CSCI0931, 
CSCI1010, CSCI1230, CSCI1234, CSCI1250, CSCI1260, CSCI1270, 
CSCI1280, CSCI1290, CSCI1300, CSCI1301, CSCI1310, CSCI1320, 
CSCI1330, CSCI1340, CSCI1370, CSCI1380, CSCI1410, CSCI1420, 
CSCI1430, CSCI1440, CSCI1450, CSCI1460, CSCI1470, CSCI1480, 
CSCI1490, CSCI1510, CSCI1550, CSCI1570, CSCI1575, CSCI1580,
CSCI1590, CSCI1600, CSCI1610, CSCI1620, CSCI1650, CSCI1660, 
CSCI1670, CSCI1680, CSCI1690, CSCI1695, CSCI1710, CSCI1729,
CSCI1730, CSCI1760, CSCI1780, CSCI1800, CSCI1805, CSCI1810, 
CSCI1820, CSCI1850, CSCI1870, CSCI1900, CSCI1950E, CSCI1950H, 
CSCI1950I, CSCI1950N, CSCI1950Q, CSCI1950R, CSCI1950S, CSCI1950T, 
CSCI1950U, CSCI1950V, CSCI1950W, CSCI1950X, CSCI1950Y, CSCI1950Z,
CSCI1951A, CSCI1951B, CSCI1951C, CSCI1951D, CSCI1951E, CSCI1951G, 
CSCI1951H, CSCI1951I, CSCI1951J, CSCI1951K, CSCI1951L, CSCI1951M, CSCI1951N, 
CSCI1951O, CSCI1951R, CSCI1951S, CSCI1951T, CSCI1951U, CSCI1951V, 
CSCI1951W, CSCI1970, CSCI1971, CSCI1972, CSCI2000, CSCI2240, 
CSCI2270, CSCI2300, CSCI2310, CSCI2330, CSCI2340, CSCI2370, 
CSCI2390, CSCI2410, CSCI2420, CSCI2440, CSCI2470, CSCI2500A, 
CSCI2500B, CSCI2510, CSCI2520, CSCI2531, CSCI2540, CSCI2550, 
CSCI2560, CSCI2570, CSCI2580, CSCI2590, CSCI2730, CSCI2750, 
CSCI2820, CSCI2950C, CSCI2950E, CSCI2950G, CSCI2950J, CSCI2950K, 
CSCI2950L, CSCI2950O, CSCI2950P, CSCI2950Q, CSCI2950R, CSCI2950T, 
CSCI2950U, CSCI2950V, CSCI2950W, CSCI2950X, CSCI2950Z, CSCI2951A,
CSCI2951B, CSCI2951C, CSCI2951D, CSCI2951E, CSCI2951F, CSCI2951G, 
CSCI2951H, CSCI2951I, CSCI2951J, CSCI2951K, CSCI2951L, CSCI2951M, 
CSCI2951N, CSCI2951O, CSCI2951P, CSCI2951Q, CSCI2951R, CSCI2951S, 
CSCI2951T, CSCI2951U, CSCI2951V, CSCI2951W, CSCI2951X, CSCI2951Y, 
CSCI2951Z, CSCI2952A, CSCI2952B, CSCI2952C, CSCI2952D, CSCI2952E, 
CSCI2952F, CSCI2952G, CSCI2952H, CSCI2952I, CSCI2952J, CSCI2952K, 
CSCI2952V, CSCI2955, CSCI2956F, CSCI2980, 
DATA0080, DATA0200, DATA1030, DATA1050, DATA2040, DATA2050,
DATA2080, MATH0520, MATH0350, MATH0540 extends Course {}

abstract sig Pathway {
	assignedCourses: set Course,
	core: set Course,
	related: set Course
}
one sig MLPath, CompBioPath, ArchitecturePath, DataPath, DesignPath, 
SecurityPath, SoftwarePath, SystemsPath, TheoryPath, VisualCompPath extends Pathway {}

fact requirementsForSecurityPath {
	SecurityPath.core = (CSCI1510 + CSCI1650 + CSCI1660)
	SecurityPath.related = (CSCI1320 + CSCI1380 + CSCI1670 + CSCI1680 + CSCI1730 + CSCI1800 + CSCI1805 + CSCI1950Y)
	all p: Plan | SecurityPath in p.pathways implies {
		some p.courses & (CSCI0220 + APMA1650 + APMA1655 + CSCI1450)
		some p.courses & (CSCI0300 + CSCI0330)
	}
}

fact requirementsForTheoryPath {
	TheoryPath.core = (CSCI1510 + CSCI1550 + CSCI1570 + CSCI1760 + CSCI1951W) 
	TheoryPath.related = (CSCI1810 + CSCI1820 + CSCI1950H + CSCI1950Y + CSCI1951G + CSCI1951K)
	all p: Plan | TheoryPath in p.pathways implies {
		some p.courses & (CSCI0530 + MATH0520 + MATH0540)	
		some p.courses & (CSCI1010)
		some p.courses & (CSCI0300 + CSCI0330)
	}
}

pred isCapstonableCourse[c: Course] {
	c in (CSCI1234 +
		CSCI1260 +
		CSCI1290 +
		CSCI1300 +
		CSCI1320 +
		CSCI1370 +
		CSCI1380 +
		CSCI1410 +
		CSCI1420 +
		CSCI1430 +
		CSCI1440 +
		CSCI1470 +
		CSCI1600 +
		CSCI1620 +
		CSCI1690 +
		CSCI1680 +
		CSCI1760 +
		CSCI1950Y +
		CSCI1951A +
		CSCI1951I +
		CSCI1951U +
		CSCI2240 +
		CSCI2370 +
		CSCI2390 +
		CSCI2420 +
		CSCI2500B +
		CSCI2510 +
		CSCI2950T +
		CSCI2950V +
		CSCI2951I +
		CSCI2952K)
}

fun numberOfArtsSocialCourses[courses: set Course]: Int {
	#(courses & (CSCI1250 + CSCI1280 + CSCI1370 + CSCI1800 + CSCI1805 + CSCI1870))
}

abstract sig DegreeType {}
one sig ABDegree, ScBDegree extends DegreeType {}

sig Plan {
	-- Set of all courses in the plan
	courses: set Course,
	-- Degree type of the plan
	degreeType: one DegreeType,
	-- Pathways chosen in the plan
	pathways: some Pathway,
	-- Chosen capstone
	capstone: lone Course,
	-- Chosen electives
	electives: set Course
}

fact onePlan {
	#Plan > 0
	all p: Plan | p.degreeType = ScBDegree
	all p: Plan | SecurityPath in p.pathways and TheoryPath in p.pathways
}

-- ScBDegree

pred doesPlanSatisfyConcentration[p: Plan] {
	p.degreeType = ScBDegree implies {
		-- If ScB, two pathways
		#(p.pathways) = 2

		-- If ScB, is there a capstone?
		some p.capstone and p.capstone in p.courses
		isCapstonableCourse[p.capstone]

		-- If ScB, is the capstone in one of the pathways?
		p.capstone in p.pathways.assignedCourses

		-- Has 15 courses
		#(p.courses) >= 15
	}

	-- Does the student have a 1000-level CS course that is not in one of the pathways?
	some p.electives - (p.pathways.core + p.pathways.related)

	-- Are any 1000-level courses from outside CS in the list of approved courses?
	-- I think this is covered implicity by the course definition sigs?

	-- Taken allowed number of arts, society, and policy?
	numberOfArtsSocialCourses[p.courses] <= 4
}

-- Pathways

pred satisfiesPathway[p: Plan, core: Course, related: Course] {
	-- Core Courses
	some p.courses & core
	-- Related Courses
	#(p.courses & (core + related)) >= 2
}

assert doesPlanSatisfyConcentration {
	all p: Plan | 
}
check doesPlanSatisfyConcentration for 10 but 1 Plan, 200 Course, 5 int

