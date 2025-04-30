using Lux, Reactant

for (i, dev) in enumerate(Reactant.devices())
    println("[", i, "] ", string(dev))
end
