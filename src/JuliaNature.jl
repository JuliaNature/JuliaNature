module JuliaNature

# Write your package code here.


   
using Statistics


struct Bat_model
    pop_size::int
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
end

function initialize(size::int, obj_func, velocity_range, posit_range, freq_range, loudness_range)
    bat_velocity = rand(velocity_range[1]:.01:velocity_range[2], size)
    bat_position = rand(posit_range[1]:.01:posit_range[2], size)
    frequencies = rand(freq_range[1]:.01:freq_range[2], size)
    pulse_rates = rand(0:.01:1, size)
    loudness = rand(loudness_range[1]:.01:loudness_range[2], size)
    return Bat_model(size, obj_func, bat_position, bat_velocity,  frequencies, pulse_rates, loudness, freq_range[1], freq_range[2], loudness_range[1], loudness_range[2])
end


function optimize(algo::Bat_model)
    t = 0
    best_val = 0
    solution = obj_func(2, 4)
    while t < algo.max_iter
        best = 99999999999
        best_ind = -1
        for i in 1: algo.pop_size
            if algo.position[i] - solution < best: 
                best = algo.position[i] - solution
                best_ind = i
            end
        for i in 1: algo.pop_size
            beta = rand(0:.01:1, 1)
            algo.freq_pulse[i] = algo.freq_min + (algo.freq_max - algo.freq_min) *  beta
            algo.velocity[i] = algo.velocity[i] + (algo.position[i] - algo.position[best_ind]) * algo.freq_pulse[i]
            algo.position[i] = algo.position[i] + algo.velocity[i]
        end

        best = 99999999999
        best_ind = -1
        for i in 1: algo.pop_size
        if algo.position[i] - solution < best: 
            best = algo.position[i] - solution
            best_ind = i
            best_val = algo.position[i]
        end
        scaling = 0.01
        avg = mean(algo.position)
        for i in 1:algo.pop_size
            e = rand(-1:0.01:1, 1)
            algo.position[i] = algo.position[i] + scaling * e * avg
        end
        alpha = 0.9
        yamma = 0.9
        for i in 1:algo.pop_size
            algo.loudness[i] = alpha * algo.loudness[i]         
        end
end

function best(bats::bat)