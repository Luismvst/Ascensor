#define PISOS 4
#define SUBIR 2
#define BAJAR 1
/*struct Pulsos
{
	int piso;
	bool direccion;
};*/
//INPUTS
	//el valor de boton significa el estado de un boton (0 no pulado, 1 pulsado) y su posicion en el vector, el piso
	bool boton [PISOS];

	//piso actual del ascensor, el piso con un 1 será la posicion del ascensor
	//sensor de piso
	bool piso [PISOS];

//OUTPUTS
	//motor de movimiento del ascensor, con m_bajar solo astivado baja, con m_subir solo activado sube; cualquier otro quieto
	bool m_bajar, m_subir;

	//puertas del ascensor, 1 abiertas, 0 cerradas
	bool puertas;

//MEMORY
	//destino 
	int destino;

/*	//Memoria, guarda un 0 sin o hay nadie en la cola,
	struct Pulsos* memoria[4];*/



//nos comara el piso actual con el destino y nos devuelve un SUBIR si se sube y un BAJAR si baja; devuelve 0 para no movimiento
int calcularMovimiento(int piso, int destino);
bool leerBotones (bool botones [],int* destino/*, bool* direccion*/);
/*void initMemo();*/


int main()
{
	destino=0;
	/*initMemo();*/
	while (1)
	{
		if(piso!=destino )
		{
			//ESTADO MOVIMIENTO
			puertas=0;
			int movimiento=calcularMovimiento(piso,destino);
			if (movimiento==SUBIR)
			{
				m_subir=1;
				m_bajar=0;
			}
			else if (movimiento==BAJAR)
			{
				m_subir=0;
				m_bajar=1;
			}
			continue;
		}
		//ESTADO REPOSO
		puertas=1;
		leerBotones(*boton, &destino/*, int &direccion*/);
	}
}


int calcularMovimiento (int piso, int destino)
{
	if (piso==destino)
		return 0;
	else if(piso<destino)
		return SUBIR;
	else if(piso>destino)
		return BAJAR;
}
bool leerBotones (bool botones [],int* destino/*, bool* direccion*/)
{
	for(int n=0;n<PISOS;n++)
	{
		if (botones[n])
		{
			&destino=n;
			return true;
		}
	}
	return false;
}