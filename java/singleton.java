/**
 * Technique du Holder
 * http://thecodersbreakfast.net/index.php?post/2008/02/25/26-de-la-bonne-implementation-du-singleton-en-java
 * 
 * Elle repose sur l'utilisation d'une classe interne privée, responsable de
 * l'instanciation de l'instance unique du Singleton.
**/
public class Singleton
{		
	/** Constructeur privé */	
	private Singleton()
	{}
 
	/** Holder */
	private static class SingletonHolder
	{		
		/** Instance unique non préinitialisée */
		private final static Singleton instance = new Singleton();
	}
 
	/** Point d'accès pour l'instance unique du singleton */
	public static Singleton getInstance()
	{
		return SingletonHolder.instance;
	}
}

/**
 * Cette technique joue sur le fait que la classe interne ne sera chargée en
 * mémoire que lorsque l'on y fera référence pour la première fois, c'est-à-
 * -dire lors du premier appel de "getInstance()" sur la classe Singleton.
 * Lors de son chargement, le Holder initialisera ses champs statiques et
 * créera donc l'instance unique du Singleton.
 * Cerise sur le gâteau, elle fonctionne correctement en environnement
 * multithreadé et ne nécessite aucune synchronisation explicite !
**/
