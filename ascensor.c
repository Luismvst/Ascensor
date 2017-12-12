#define PISOS 4
#define SUBIR 2
#define BAJAR 1
/*struct Pulsos
{
	int piso;
	bool direccion;
};*/
//INPUTS
	//cada piso tiene 2 botones, si se recibe un "subir" entra un 1, si es "bajar", un 0
	//el valor de boton significa el estado de un boton
	bool boton [PISOS];

	//piso actual del ascensor
	//sensor de piso
	int piso;

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
bool leerBotones (bool botones [],int* piso/*, bool* direccion*/);
/*void initMemo();*/


int main()
{
	destino=0;
	/*initMemo();*/
	while (1)
	{
		if(piso!=destino )
		{
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
		leerBotones(*boton, &destino/*, int &direccion*/);

	}

}


int calcularMovimiento (int piso, int destino)
{
	if (piso==destino)
		return 0;
	else if(piso-destino<0)
		return SUBIR;
	else if(piso-destino>0)
		return BAJAR;
}
bool leerBotones (bool botones [],int* piso/*, bool* direccion*/)
{
	for(int n=0;n<PISOS;n++)
	{
		if (boton[n])
		{
			&piso=n;
			return true;
		}
	}
	return false;
}
