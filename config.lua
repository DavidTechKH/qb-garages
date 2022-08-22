QBCore = exports['qb-core']:GetCoreObject()

AutoRespawn = false

Garages = {
    --Public Garage:
	['a'] = {
        label = 'Pinkcage Parking',
        spawnPoint = {
			vector4(277.81, -340.25, 44.92, 76.9),
			vector4(278.42, -336.52, 44.92, 72.35),
			vector4(280.16, -333.59, 44.92, 70.03),
			vector4(281.39, -330.14, 44.92, 69.62),
			vector4(282.58, -327.01, 44.92, 76.52),
			vector4(283.57, -323.85, 44.92, 75.12),
		},
		blippoint = vector3(280.34, -332.05, 44.92),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(273.69860839844, -340.84005737305),
			vector2(280.69244384766, -321.66775512695),
			vector2(292.60189819336, -325.54788208008),
			vector2(285.55899047852, -344.95938110352)
        },
        minZ = 44.919876098633,
        maxZ = 44.919876098633
    },
	['b'] = {
        label = 'B Parking',
        spawnPoint = {
			vector4(-16.06, -1113.68, 26.25, 68.78),
			vector4(-14.76, -1110.73, 26.25, 70.2),
			vector4(-13.59, -1107.67, 26.25, 71.15),
			vector4(-12.53, -1104.72, 26.25, 69.67)
		},
		blippoint = vector3(-14.5, -1109.46, 26.92),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(-20.64, -1113.55),
			vector2(-14.68, -1116.06),
			vector2(-7.9, -1098.57),
			vector2(-14.62, -1095.61)
        },
		minZ = 19.836761474609,
		maxZ = 20.649192810059
    },
	['c'] = {
        label = 'C Parking',
        spawnPoint = {
			vector4(810.27, -732.38, 26.77, 132.0),
			vector4(808.13, -729.34, 26.78, 130.0),
			vector4(805.91, -726.96, 26.8, 132.41),
		},
		blippoint = vector3(808.7, -729.18, 26.77),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(813.73, -731.89),
			vector2(807.78, -737.01),
			vector2(800.43, -729.63),
			vector2(807.04, -723.27)
        },
		minZ = 26.076713562012,
		maxZ = 26.850509643555
    },
	['d'] = {
        label = 'D Parking',
        spawnPoint = {
            vector4(-595.34, -1111.94, 21.51, 269.95),
            vector4(-595.33, -1115.76, 21.5, 270.42),
            vector4(-594.96, -1119.41, 21.51, 270.5),
            vector4(-595.05, -1122.87, 21.51, 270.9),
			vector4(-595.38, -1126.75, 21.51, 271.37),
			vector4(-595.34, -1130.26, 21.51, 267.84)
		},
		blippoint = vector3(-595.23, -1120.72, 21.5),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(-589.79, -1108.8),
			vector2(-598.04, -1109.69),
			vector2(-598.23, -1132.66),
			vector2(-589.28, -1132.35)
        },
		minZ = 20.97863769531,
		maxZ = 21.32524108887
    },
	['e'] = {
        label = 'E Parking',
        spawnPoint = {
            vector4(-811.26, 187.66, 71.98, 110.08)
		},
		blippoint = vector3(-811.26, 187.66, 71.98),
        showBlip = false,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(-813.87, 184.05),
			vector2(-815.55, 188.57),
			vector2(-809.38, 190.76),
			vector2(-806.92, 186.64)
        },
		minZ = 71.6750658035278,
		maxZ = 71.9949150848389
    },
    ["f"] = {
        label = "F Parking",
        spawnPoint = {
            vector4(22.56, 544.33, 175.53, 60.88)
		},
		blippoint = vector3(22.56, 544.33, 175.53),
        showBlip = false,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(24.17, 540.67),
			vector2(26.42, 544.87),
			vector2(20.7, 548.34),
			vector2(18.26, 543.55)
        },
  		minZ = 4.3796696662903,
  		maxZ = 4.5596661567688
    },
    ["g"] = {
        label = "G Parking",
        spawnPoint = {
            vector4(1117.06, 2646.67, 38.0, 1.24),
            vector4(1120.79, 2647.1, 38.0, 354.35),
            vector4(1124.33, 2647.02, 38.0, 350.84),
            vector4(1127.81, 2647.09, 38.0, 357.03),
            vector4(1131.7, 2646.77, 38.0, 359.8),
			vector4(1135.58, 2647.09, 37.39, 359.32)
		},
		blippoint = vector3(1123.97, 2647.13, 38.0),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(1114.4346923828, 2650.7321777344),
			vector2(1114.4858398438, 2644.8132324219),
			vector2(1137.0805664062, 2644.8271484375),
			vector2(1137.0849609375, 2650.5405273438)
        },
		minZ = 37.996112823486,
		maxZ = 37.996604919434
    },
	["h"] = {
        label = "H Parking",
        spawnPoint = {
			vector4(-9.16, -1474.57, 29.72, 318.8)
		},
		blippoint = vector3(-9.16, -1474.57, 29.72),
        showBlip = false,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(-13.17, -1475.63),
			vector2(-8.93, -1478.91),
			vector2(-3.97, -1473.09),
			vector2(-8.93, -1469.27)
        },
		minZ = 29.374645233154,
		maxZ = 29.837837219238
    },
	["i"] = {
        label = "Sandy Parking",
        spawnPoint = {
			vector4(1737.69, 3719.32, 33.43, 20.71)
		},
		blippoint = vector3(1737.44, 3719.46, 33.63),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(1741.7010498047, 3716.3913574219),
			vector2(1738.6027832031, 3723.6875),
			vector2(1734.0430908203, 3721.9631347656),
			vector2(1736.9338378906, 3714.6008300781)
        },
		minZ = 33.97981262207,
		maxZ = 34.114082336426
    },
	["j"] = {
        label = "Paleto Parking",
        spawnPoint = {
            vector4(81.21, 6396.43, 31.23, 130.18),
            vector4(78.42, 6399.02, 31.23, 130.95),
            vector4(75.68, 6401.8, 31.23, 128.77),
            vector4(72.66, 6404.42, 31.23, 131.56),
		},
		blippoint = vector3(77.32, 6400.62, 31.23),
        showBlip = true,
		blipsprite = 357,
		blipscale = 0.65,
		blipcolour = 3,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(73.350646972656, 6407.97265625),
			vector2(68.870704650879, 6403.8647460938),
			vector2(80.044586181641, 6392.5380859375),
			vector2(84.957252502441, 6397.0024414062)
        },
		minZ = 31.225761413574,
		maxZ = 31.226146697998
    },
	['impound'] = {
        label = 'Impound',
        spawnPoint = {
			vector4(-198.22, -1173.67, 22.62, 198.39),
			vector4(-194.53, -1173.88, 22.62, 200.29),
			vector4(-191.16, -1173.76, 22.62, 198.82)
		},
		blippoint = vector3(-193.2453, -1162.2804, 23.6714),
        showBlip = true,
		blipsprite = 68,
		blipscale = 0.7,
		blipcolour = 5,
		job = nil, -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 0, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(-187.6329498291, -1167.2894287109),
			vector2(-192.19451904297, -1167.3923339844),
			vector2(-192.06999206543, -1164.9278564453),
			vector2(-194.44012451172, -1164.9467773438),
			vector2(-194.43879699707, -1161.0749511719),
			vector2(-187.66923522949, -1161.0802001953)
        },
		minZ = 23.67138671875,
		maxZ = 23.679424285889
    },
	--Job Garage:
	['police'] = {
        label = 'PD Personal Parking',
        spawnPoint = {
            vector4(425.26, -976.09, 25.51, 269.72),
            vector4(425.25, -978.85, 25.51, 269.0),
            vector4(425.35, -981.52, 25.51, 270.74),
            vector4(425.44, -984.26, 25.51, 270.95),
		},
		job = 'police', -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(429.47, -985.62),
			vector2(423.13, -986.38),
			vector2(423.15, -974.26),
			vector2(429.09, -974.24)
        },
		minZ = 24.6998462677,
		maxZ = 25.699855804443
    },
	['ambulance'] = {
        label = 'Ambulance Parking',
        spawnPoint = {
            vector4(321.4, -565.43, 28.19, 247.22),
            vector4(319.63, -569.81, 28.19, 249.9),
            vector4(317.75, -573.94, 28.19, 250.98)
		},
		job = 'ambulance', -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 1, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(320.87, -568.01),
			vector2(320.87, -568.01),
			vector2(320.87, -568.01),
			vector2(320.87, -568.01)
        },
		minZ = 6.5372638702393,
		maxZ = 6.934118270874
    },
	['impoundpolice'] = {
        label = 'Impound Police',
        spawnPoint = {
			vector4(435.61, -975.95, 25.09, 91.7)
		},
		job = 'police', -- [nil: public garage] ['police: police garage'] ...
		fullfix = false, -- [true: full fix when take out vehicle]
		garastate = 2, -- [0: Depot] [1: Garage] [2: Impound]
		zones = {
			vector2(441.62, -978.17),
			vector2(442.44, -973.76),
			vector2(431.59, -973.67),
			vector2(431.13, -978.22)
        },
		minZ = 91.2,
		maxZ = 91.8
    }
}