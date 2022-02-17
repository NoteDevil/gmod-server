
BM2CONFIG = {}

//Setting this to false will disable the generator from making sound.
BM2CONFIG.GeneratorsProduceSound = true

//Dollas a bitcoins sells for. Dont make this too large or it will be too easy to make money
BM2CONFIG.BitcoinValue = 250

//This is a value that when raising or lowering will effect the speed of all bitminers.
//This is a balanced number and you should only change it if you know you need to. Small increments make big differences
BM2CONFIG.BaseSpeed = 0.004

//The higher this number, the faster the generator will loose fuel.
//You can use this to balance out more so they need to buy fuel more frequently
BM2CONFIG.BaseFuelDepletionRate = 0.9