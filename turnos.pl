def_type(fh,[fecha,hora]).

def_type(tur,rel(fh,dni)).
def_type(pac,rel(dni,nombre)).

%% Consultorio

dec_p_type(consultorioInit(tur,pac)).
consultorioInit(Turnos,Pacientes) :-
  Turnos = {} &
  Pacientes = {}.

dec_p_type(consultorioInv(tur,pac)).
consultorioInv(Turnos,Pacientes) :-
  dec([D1,D2],set(dni)) &
  ran(Turnos,D1) &
  dom(Pacientes,D2) &
  subset(D1,D2).


%% AltaPaciente

dec_p_type(altaPacienteOk(tur,pac,dni,nombre,tur,pac)).
altaPacienteOk(Turnos,Pacientes,D_i,N_i,Turnos_,Pacientes_) :-
  dec(P,set(dni)) &
  dom(Pacientes,P) &
  D_i nin P &
  un(Pacientes,{[D_i,N_i]},Pacientes_) &
  Turnos_ = Turnos.

dec_p_type(pacienteYaExiste(tur,pac,dni,tur,pac)).
pacienteYaExiste(Turnos,Pacientes,D_i,Turnos_,Pacientes_) :-
  dec(P,set(dni)) &
  dom(Pacientes,P) &
  D_i in P &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(altaPaciente(tur,pac,dni,nombre,tur,pac)).
altaPaciente(Turnos,Pacientes,D_i,N_i,Turnos_,Pacientes_) :-
  altaPacienteOk(Turnos,Pacientes,D_i,N_i,Turnos_,Pacientes_)
  or
  pacienteYaExiste(Turnos,Pacientes,D_i,Turnos_,Pacientes_).


%% BajaPaciente

dec_p_type(bajaPacienteOk(tur,pac,dni,tur,pac)).
bajaPacienteOk(Turnos,Pacientes,D_i,Turnos_,Pacientes_) :-
  dec([P,T],set(dni)) &
  dom(Pacientes, P) &
  D_i in P &
  ran(Turnos,T) &
  D_i nin T &
  dares({D_i},Pacientes,Pacientes_) &
  Turnos_ = Turnos.

dec_p_type(pacienteNoExiste(tur,pac,dni,tur,pac)).
pacienteNoExiste(Turnos,Pacientes,D_i,Turnos_,Pacientes_) :-
  dec(P,set(dni)) &
  dom(Pacientes,P) &
  D_i nin P &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(pacienteTieneTurnos(tur,pac,dni,tur,pac)).
pacienteTieneTurnos(Turnos,Pacientes,D_i,Turnos_,Pacientes_) :-
  dec(T,set(dni)) &
  ran(Turnos,T) &
  D_i in T &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(bajaPaciente(tur,pac,dni,tur,pac)).
bajaPaciente(Turnos,Pacientes,D_i,Turnos_,Pacientes_) :-
  bajaPacienteOk(Turnos,Pacientes,D_i,Turnos_,Pacientes_)
  or
  pacienteNoExiste(Turnos,Pacientes,D_i,Turnos_,Pacientes_)
  or
  pacienteTieneTurnos(Turnos,Pacientes,D_i,Turnos_,Pacientes_).


%% AltaTurno

dec_p_type(altaTurnoOk(tur,pac,fecha,hora,dni,tur,pac)).
altaTurnoOk(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_) :-
  dec(P,set(dni)) &
  dom(Pacientes,P) &
  D_i in P &
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] nin T &
  un(Turnos,{[[F_i,H_i],D_i]},Turnos_) &
  Pacientes_ = Pacientes.

dec_p_type(turnoYaAsignado(tur,pac,fecha,hora,tur,pac)).
turnoYaAsignado(Turnos,Pacientes,F_i,H_i,Turnos_,Pacientes_) :-
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] in T &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(altaTurno(tur,pac,fecha,hora,dni,tur,pac)).
altaTurno(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_) :-
  altaTurnoOk(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_)
  or
  pacienteNoExiste(Turnos,Pacientes,D_i,Turnos_,Pacientes_)
  or
  turnoYaAsignado(Turnos,Pacientes,F_i,H_i,Turnos_,Pacientes_).


%% BajaTurno

dec_p_type(bajaTurnoOk(tur,pac,fecha,hora,dni,tur,pac)).
bajaTurnoOk(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_) :-
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] in T &
  applyTo(Turnos,[F_i,H_i],D_i) &
  dares({[F_i,H_i]},Turnos,Turnos_) &
  Pacientes_ = Pacientes.

dec_p_type(turnoNoAsignado(tur,pac,fecha,hora,tur,pac)).
turnoNoAsignado(Turnos,Pacientes,F_i,H_i,Turnos_,Pacientes_) :-
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] nin T &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(turnoNoCoincide(tur,pac,fecha,hora,dni,tur,pac)).
turnoNoCoincide(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_) :-
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] in T &
  dec(D,dni) &
  applyTo(Turnos,[F_i,H_i],D) &
  D_i neq D &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(bajaTurno(tur,pac,fecha,hora,dni,tur,pac)).
bajaTurno(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_) :-
  bajaTurnoOk(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_)
  or
  turnoNoAsignado(Turnos,Pacientes,F_i,H_i,Turnos_,Pacientes_)
  or
  turnoNoCoincide(Turnos,Pacientes,F_i,H_i,D_i,Turnos_,Pacientes_).


%% TurnosPaciente

dec_p_type(turnosPaciente(tur,pac,dni,set(fh),tur,pac)).
turnosPaciente(Turnos,Pacientes,D_i,T_o,Turnos_,Pacientes_) :-
  dec(T,tur) &
  rres(Turnos,{D_i},T) &
  dom(T,T_o).
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.


%% NombreTurno

dec_p_type(nombreTurnoOk(tur,pac,fecha,hora,nombre,tur,pac)).
nombreTurnoOk(Turnos,Pacientes,F_i,H_i,N_o,Turnos_,Pacientes_) :-
  dec(T,set(fh)) &
  dom(Turnos,T) &
  [F_i,H_i] in T &
  dec(D,dni) &
  applyTo(Turnos,[F_i,H_i],D) &
  applyTo(Pacientes,D,N_o) &
  Turnos_ = Turnos &
  Pacientes_ = Pacientes.

dec_p_type(nombreTurno(tur,pac,fecha,hora,nombre,tur,pac)).
nombreTurno(Turnos,Pacientes,F_i,H_i,N_o,Turnos_,Pacientes_) :-
  nombreTurnoOk(Turnos,Pacientes,F_i,H_i,N_o,Turnos_,Pacientes_)
  or
  turnoNoAsignado(Turnos,Pacientes,F_i,H_i,Turnos_,Pacientes_).
