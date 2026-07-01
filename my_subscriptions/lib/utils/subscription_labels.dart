String billingCycleLabel(String cycle) {
  return switch (cycle) {
    'WEEKLY' => 'Settimanale',
    'MONTHLY' => 'Mensile',
    'QUARTERLY' => 'Trimestrale',
    'YEARLY' => 'Annuale',
    'CUSTOM' => 'Personalizzato',
    _ => cycle,
  };
}

String statusLabel(String status) {
  return switch (status) {
    'ACTIVE' => 'Attivo',
    'TRIAL' => 'Trial',
    'PAUSED' => 'In pausa',
    'CANCELLED' => 'Cancellato',
    _ => status,
  };
}
