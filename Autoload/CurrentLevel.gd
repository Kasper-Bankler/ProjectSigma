extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0
var tile_hover_type = ""
var is_playing = true
var co2_emitted = 0

 
signal new_building_placed
signal building_upgraded


var LEVELS_STATS = {1:{"wind": 0.5, "sun": 0.4, "energy_required": 100, "level": 1},
2:{"wind": 0.3, "sun": 1.0, "energy_required": 500, "level": 2},
3:{"wind": 0.7, "sun": 0.0, "energy_required": 1000, "level": 3},
4:{"wind": 1.0, "sun": 0.3, "energy_required":5000, "level": 4},
5:{"wind": 0.0, "sun": 0.2, "energy_required": 10000, "level": 5},
6:{"wind": 0.8, "sun": 0.7, "energy_required": 50000, "level": 6},
} 

var FAKTABOKS={"0":"Kulbrændstoffer som kul og olie er ikke så gode for vores planet. Når vi brænder dem for at lave energi, slipper de farlige stoffer som CO2 ud i luften, og det er ikke godt for miljøet. Derfor er der nogle steder en grøn afgift på at bruge kulbrændstoffer, for at få folk til at bruge mere miljøvenlige alternativer som solceller.",
"1":"Solceller er som magiske kasser, der omdanner sollys direkte til elektricitet. De er rene og grønne, fordi de ikke udleder skadelige stoffer. Solceller er en vigtig del af vores grønne fremtid, da de reducerer vores afhængighed af forurenende energikilder som kul og olie.",
"2":"Vindmøller er store konstruktioner, der udnytter vindens energi til at producere elektricitet. Verden over er der tusindvis af vindmøller, der arbejder sammen for at generere ren og vedvarende energi. I 2020 var der mere end 340.000 vindmøller globalt, og dette tal vokser stadig, da flere lande investerer i vedvarende energikilder som vindkraft. Disse vindmølleparker spænder over land og hav, og de bidrager til at reducere vores afhængighed af fossile brændstoffer og mindske udledningen af drivhusgasser. Ved at investere i vindenergi kan vi bevæge os mod en mere bæredygtig og ren energifremtid.",
"3":"Atomkraftværker er store anlæg, der bruger energi fra atomkerner til at producere elektricitet. De udgør en vigtig del af verdens energiforsyning og står for en betydelig del af den globale elektricitetsproduktion. Atomkraftværker producerer ikke CO2 under selve driftsprocessen, hvilket gør dem til en lavemissionskilde til elektricitet. Dog er der bekymringer omkring sikkerhed og håndtering af radioaktivt affald, som kræver omhyggelig overvågning og regulering.",
"4":"Biogasanlæg er faciliteter, der omdanner organisk materiale som affald, gylle eller biomasse til biogas og gødning. Processen kaldes anaerob fordøjelse, hvor mikroorganismer nedbryder det organiske materiale under iltfrie forhold og producerer biogas som et resultat. Biogassen, som primært består af methan, kan bruges som en vedvarende energikilde til opvarmning, elektricitetsproduktion eller som brændstof til køretøjer. Samtidig producerer biogasanlægget også en næringsrig gødning, der kan bruges til at forbedre jordens frugtbarhed. Biogasanlæg spiller en vigtig rolle i at reducere organisk affald og fremme bæredygtig energiproduktion."}

var currentLevel = LEVELS_STATS[1]
