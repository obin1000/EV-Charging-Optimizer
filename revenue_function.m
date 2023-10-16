function revenue = revenue_function(number_ports, VC_m_per_port, Price_charging_hourly, VC_elec_per_port, D_t)
    revenue = sum(- number_ports * VC_m_per_port + (Price_charging_hourly - VC_elec_per_port) .* min(D_t, number_ports));
end