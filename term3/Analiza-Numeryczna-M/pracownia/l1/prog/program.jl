# Autor: Sławomir Górawski

function stairs_up(a, b)
    n = length(a)
    u = b[end]
    for k=n:-1:1
        u = a[k] / u + b[k]
    end
    return u
end

function stairs_down(a, b)
    n = length(a)
    # initial values
    p_previous = 1
    p_current = b[1]
    q_previous = 0
    q_current = 1
    for k=1:n
        (p_next, q_next) = stairs_down_iteration_step(a[k], b[k + 1],
                                                      p_previous,
                                                      p_current,
                                                      q_previous,
                                                      q_current)

        p_previous = p_current
        p_current = p_next
        q_previous = q_current
        q_current = q_next
    end
    return p_current / q_current
end

function stairs_down_iteration_step(a_k, b_kp1,
                                    p_previous,
                                    p_current,
                                    q_previous,
                                    q_current)
    p_next = b_kp1 * p_current + a_k * p_previous
    q_next = b_kp1 * q_current + a_k * q_previous
    return (p_next, q_next)
end