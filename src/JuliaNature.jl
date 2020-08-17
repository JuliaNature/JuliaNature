module JuliaNature

# Write your package code here.


   
using Statistics


struct Bat_model
    pop_size::Int
    dims::Int
    obj_func
    position
    velocity
    freq_pulse
    pulse_rate
    loudness
    freq_max
    freq_min
    loud_max
    loud_min
    type # 0 - min , 1 - max
end

function initialize(size::Int, dims::Int, obj_func, velocity_range, posit_range, freq_range, loudness_range, type)
    bat_velocity = [rand(velocity_range[1]:.001:velocity_range[2],dims) for i in 1:size]
    bat_position = [rand(posit_range[1]:.001:posit_range[2],dims) for i in 1:size]
    frequencies = [rand(freq_range[1]:.001:freq_range[2],dims) for i in 1:size]
    pulse_rates = [rand(0:.001:1,dims) for i in 1:size]
    loudness = [rand(loudness_range[1]:.001:loudness_range[2],dims) for i in 1:size]
    return Bat_model(size, dims, obj_func, bat_position, bat_velocity,  frequencies, pulse_rates, loudness, [freq_range[1]
    for i in 1:dims], [freq_range[2] for i in 1:dims] , [loudness_range[1] for i in 1:dims], [loudness_range[2] for i in 1:dims], type)
end


function optimize(algo::Bat_model, iter=50, tol= 0.3)
    t = 1
    best_ind = 1
    println(best_ind)
    if algo.type == 0
            best = typemax(typeof(1.0))
        else
            best = typemin(typeof(1.0))
        end
        plus_0 = algo.pulse_rate
        for i in 1: algo.pop_size
            if algo.type == 0
                if algo.obj_func(algo.position[i]...) < best
                    best = algo.obj_func(algo.position[i]...)
                    best_ind = i
                end
            else
                if algo.obj_func(algo.position[i]...) > best 
                    best = algo.obj_func(algo.position[i]...)
                    best_ind = i
                end
            end
        end
    println(algo.position[best_ind])
    println(best_ind)
    while t < iter
        alpha = 0.9
        yamma = 0.9
        for i in 1: algo.pop_size
            beta = rand(0:.001:1, algo.dims)
            algo.freq_pulse[i] = algo.freq_min + (algo.freq_max - algo.freq_min) .*  beta
            algo.velocity[i] = algo.velocity[i] + (algo.position[i] - algo.position[best_ind]) .* algo.freq_pulse[i]
            algo.position[i] = algo.position[i] + algo.velocity[i]
            r = rand(0:.01:1, algo.dims)
            if r > algo.pulse_rate[i] 
                algo.position[i] = algo.position[best_ind] + 0.01 .* r
            end
            if beta < algo.loudness[i]
                continue
            end
            if algo.type == 0
                if algo.obj_func(algo.position[i]...) < best
                    best = algo.obj_func(algo.position[i]...)
                    best_ind = i
                end
            else
                if algo.obj_func(algo.position[i]...) > best 
                    best = algo.obj_func(algo.position[i]...)
                    best_ind = i
                end
            end
            
            #scaling = 0.01
            #avg = mean(algo.position)
            #e = rand(-1:0.01:1, 1)
            #algo.position[i] = algo.position[i] + scaling .* e .* avg
            #algo.loudness[i] = alpha * algo.loudness[i]         
            #algo.pulse_rate[i] = plus_0[i] * (1 - exp(-yamma * t))
        end
        t += 1
        if abs(sum(algo.position[best_ind] - [1, 3])) < tol
            break
        end 
    end
    return algo.position[best_ind]
end

end # module