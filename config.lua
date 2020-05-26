Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 255, g = 38, b = 255}

Config.EnablePlayerManagement     = true

Config.EnableESXService           = false -- enable esx service?
Config.MaxInService               = 5

Config.Locale                     = 'fr'

Config.VigneStations = {

	Vigne = {
		Blip = {
			Coords  = vector3(-1884.236, 2058.649, 140.983),
			Sprite  = 85,
			Display = 4,
			Scale   = 1.2,
			Colour  = 27
		},
		
		Cloakrooms = {
			vector3(-1887.334, 2070.576, 145.573)
		},

		Stocks = {
			vector3(-1881.146, 2063.550, 135.915)
		},

		Vehicles = {
			{
				Spawner = vector3(-1925.473, 2048.093, 140.831),
				InsideShop = vector3(-1923.547, 2036.432, 140.969),
				SpawnPoints = {
					{coords = vector3(-1919.850, 2052.883, 140.969), heading = 256.542, radius = 6.0}
				}
			}
		},

		BossActions = {
			vector3(-1875.666, 2060.699, 145.573)
		},

		RRFarm = {
			vector3(-1815.500, 2210.101, 90.053)
		},

		RBFarm = {
			vector3(-1894.137, 1897.796, 164.766)
		},

		Traitement = {
			vector3(-1874.969, 2060.469, 134.915)
		},

		Revente = {
			vector3(839.127, -1924.870, 30.314)
		}

	}

}

Config.Zones = {
	RRFarm = {
		Pos   = {x = -1815.500,y = 2210.101,z = 90.053},
		Name  = "Récolte de Raisin Rouge"
	},
	RFarm = {
		Pos   = {x = -1894.137,y = 1897.796,z = 164.766},
		Name  = "Récolte de Raisin Blanc"
	},
	Vente = {
		Pos   = {x = 839.127,y = -1924.870,z = 30.314},
		Name  = "Zone de vente"
	}
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {
			{model = 'mule3', price = 500},
			{model = 'bison3', price = 500},
		},

		novice = {
			{model = 'mule3', price = 500},
			{model = 'bison3', price = 500},
		},

		experimente = {
			{model = 'mule3', price = 500},
			{model = 'bison3', price = 500}
		},

		viceboss = {
			{model = 'mule3', price = 500},
			{model = 'bison3', price = 500},
			{model = 'sandking', price = 1500},
			{model = 'windsor2', price = 4500}
		},

		boss = {
			{model = 'mule3', price = 500},
			{model = 'bison3', price = 500},
			{model = 'sandking', price = 1500},
			{model = 'windsor2', price = 4500}
		}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	recruit = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 0,
			torso_1 = 12,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 1,
			pants_1 = 9,   pants_2 = 7,
			shoes_1 = 7,   shoes_2 = 1,
			helmet_1 = 11,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 0, glasses_2 = 0

		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 43,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 23,
			pants_1 = 45,   pants_2 = 2,
			shoes_1 = 52,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 5, glasses_2 = 0
		}
	},

	novice = {
		male = {
			tshirt_1 = 57,  tshirt_2 = 0,
			torso_1 = 13,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 11,
			pants_1 = 9,   pants_2 = 7,
			shoes_1 = 7,   shoes_2 = 0,
			helmet_1 = 11,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 0, glasses_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 43,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 23,
			pants_1 = 45,   pants_2 = 2,
			shoes_1 = 52,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 5, glasses_2 = 0
		}
	},

	experimente = {
		male = {
			tshirt_1 = 57,  tshirt_2 = 0,
			torso_1 = 13,   torso_2 = 2,
			decals_1 = 0,   decals_2 = 0,
			arms = 11,
			pants_1 = 9,   pants_2 = 7,
			shoes_1 = 7,   shoes_2 = 0,
			helmet_1 = 11,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 0, glasses_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 43,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 23,
			pants_1 = 45,   pants_2 = 2,
			shoes_1 = 52,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 5, glasses_2 = 0
		}
	},

	viceboss = {
		male = {
			tshirt_1 = 57,  tshirt_2 = 0,
			torso_1 = 13,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 11,
			pants_1 = 9,   pants_2 = 7,
			shoes_1 = 7,   shoes_2 = 0,
			helmet_1 = 11,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 0, glasses_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 43,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 23,
			pants_1 = 45,   pants_2 = 2,
			shoes_1 = 52,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 5, glasses_2 = 0
		}
	},

	boss = {
		male = {
			tshirt_1 = 57,  tshirt_2 = 0,
			torso_1 = 13,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 11,
			pants_1 = 9,   pants_2 = 7,
			shoes_1 = 7,   shoes_2 = 0,
			helmet_1 = 11,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 0, glasses_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 43,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 23,
			pants_1 = 45,   pants_2 = 2,
			shoes_1 = 52,   shoes_2 = 3,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0,
			glasses_1 = 5, glasses_2 = 0
		}
	}
}
