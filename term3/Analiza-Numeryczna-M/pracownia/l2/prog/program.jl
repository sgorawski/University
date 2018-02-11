# Autor: Slawomir Gorawski

using Polynomials


function get_newton_coeffs(nodes, f_values)
    coeffs = Float64[]
    len = length(nodes)
    
    # First iteration
    diff_quots = collect(f_values)
    push!(coeffs, diff_quots[1])
    
    # Next iterations
    for j = 1:len-1
        for i = 1:len-j
            diff_quots[i] = ((diff_quots[i] - diff_quots[i + 1])
                             / (nodes[i] - nodes[i + j]))
        end
        push!(coeffs, diff_quots[1])
    end
    coeffs
end


function interpolate(nodes, f_values)::Poly
    coeffs = get_newton_coeffs(nodes, f_values)
    
    # First iteration
    nodal_poly = Poly([1])
    inter_poly = Poly([coeffs[1]])
    
    # Next iterations
    for i = 2:length(coeffs)
        nodal_poly *= Poly([-nodes[i - 1], 1])
        inter_poly += coeffs[i] * nodal_poly
    end
    inter_poly
end


function solve_with_newton(f, c, nodes, max_iter=100)
    f_values = map(f, nodes)
    inter_poly = interpolate(nodes, f_values) - Poly([c])

    interval_start = minimum(nodes)
    interval_end = maximum(nodes)
    x = interval_start - 1

    while !(interval_start <= x <= interval_end)
        x = rand() * (interval_end - interval_start) + interval_start
        for _ = 1:max_iter
            h_x = polyval(inter_poly, x) / polyval(polyder(inter_poly), x)
            x -= h_x
        end
    end
    x
end


function solve_with_inverse_interpolation(f, c, nodes)
    f_values = map(f, nodes)
    inverse_poly = interpolate(f_values, nodes)
    polyval(inverse_poly, c)
end