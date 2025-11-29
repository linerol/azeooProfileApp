import React from 'react';
import {
  ActivityIndicator,
  NativeModules,
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { useUserId } from '../storage/UserIdContext';

type ProfileModuleType = {
  openProfileScreen: (userId: number) => Promise<void>;
};

const { ProfileModule } = NativeModules as { ProfileModule?: ProfileModuleType };

const ProfileScreen = () => {
  const { userId, isHydrating } = useUserId();

  if (isHydrating) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color="#3B82F6" />
        <Text style={styles.helper}>Chargement...</Text>
      </View>
    );
  }

  if (!userId) {
    return (
      <View style={styles.centered}>
        <Text style={styles.title}>Aucun profil</Text>
        <Text style={styles.helper}>
          Veuillez configurer votre identifiant dans l’onglet précédent.
        </Text>
      </View>
    );
  }

  return (
    <View style={styles.centered}>
      <Text style={styles.title}>Bonjour !</Text>
      <Text style={styles.helper}>
        Votre espace personnel est prêt.
      </Text>
      <Pressable
        onPress={() => ProfileModule?.openProfileScreen(userId).catch(console.error)}
        style={styles.button}
      >
        <Text style={styles.buttonLabel}>Accéder à mon profil</Text>
      </Pressable>
    </View>
  );
};

const styles = StyleSheet.create({
  centered: {
    flex: 1,
    backgroundColor: '#F8FAFC', // Light background
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
    gap: 16,
  },
  title: {
    fontSize: 32,
    fontWeight: '800',
    textAlign: 'center',
    color: '#0F172A', // Dark text
  },
  helper: {
    fontSize: 18,
    textAlign: 'center',
    color: '#64748B',
    lineHeight: 28,
  },
  button: {
    marginTop: 24,
    borderRadius: 999,
    paddingHorizontal: 32,
    paddingVertical: 18,
    backgroundColor: '#3B82F6', // Blue primary
    shadowColor: '#3B82F6',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 12,
    elevation: 6,
  },
  buttonLabel: {
    color: 'white',
    fontSize: 18,
    fontWeight: '700',
  },
});

export default ProfileScreen;

