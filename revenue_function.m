function revenue = revenue_function(ChargeStation, number_ports, VC_m_per_port)
    %VCM_per_port is per hour
    revenue = sum([ChargeStation.Chargers.TotalCost])*1.2 - sum([ChargeStation.Chargers.TotalCost]) - number_ports * VC_m_per_port *24;
end