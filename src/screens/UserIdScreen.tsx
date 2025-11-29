import React, { useMemo, useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { useUserId } from '../storage/UserIdContext';

const UserIdScreen = () => {
  const { userId, isHydrating, updateUserId } = useUserId();
  const [value, setValue] = useState(userId?.toString() ?? '');
  const [error, setError] = useState<string | null>(null);

  const isDisabled = useMemo(
    () => isHydrating || value.trim().length === 0,
    [isHydrating, value],
  );

  const handleSave = async () => {
    setError(null);
    const parsed = Number(value);

    if (!Number.isFinite(parsed) || parsed <= 0) {
      setError('Merci de saisir un identifiant utilisateur valide (ex: 1 ou 3).');
      return;
    }

    await updateUserId(parsed);
    setError(null);
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.select({ ios: 'padding', android: undefined })}
      style={styles.container}
    >
      <View style={styles.content}>
        <Text style={styles.title}>Qui êtes-vous ?</Text>
        <Text style={styles.helper}>
          Entrez votre identifiant pour charger votre profil personnel.
        </Text>

        <TextInput
          value={value}
          onChangeText={setValue}
          keyboardType="number-pad"
          placeholder="Identifiant utilisateur"
          style={styles.input}
          placeholderTextColor="#9ca3af"
          editable={!isHydrating}
        />

        {error ? <Text style={styles.error}>{error}</Text> : null}

        <Pressable
          style={[styles.button, isDisabled && styles.buttonDisabled]}
          onPress={handleSave}
          disabled={isDisabled}
        >
          <Text style={styles.buttonLabel}>Sauvegarder</Text>
        </Pressable>

        {userId ? (
          <View style={styles.currentValue}>
            <Text style={styles.currentValueLabel}>Identifiant actif</Text>
            <Text style={styles.currentValueValue}>{userId}</Text>
          </View>
        ) : (
          <Text style={styles.helper}>Aucun identifiant sauvegardé pour le moment.</Text>
        )}
      </View>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC', // Light background
  },
  content: {
    flex: 1,
    paddingHorizontal: 24,
    paddingVertical: 32,
    gap: 16,
    justifyContent: 'center', // Center vertically
  },
  title: {
    fontSize: 28,
    fontWeight: '800',
    color: '#0F172A', // Dark text
    textAlign: 'center',
  },
  helper: {
    fontSize: 16,
    color: '#64748B',
    textAlign: 'center',
    lineHeight: 24,
  },
  input: {
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#E2E8F0',
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 20,
    paddingVertical: Platform.select({ ios: 16, android: 14 }),
    fontSize: 18,
    color: '#0F172A',
    marginTop: 20,
    shadowColor: '#64748B',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 2,
  },
  error: {
    color: '#EF4444',
    fontSize: 14,
    textAlign: 'center',
  },
  button: {
    marginTop: 12,
    borderRadius: 16,
    backgroundColor: '#3B82F6', // Blue primary
    paddingVertical: 16,
    alignItems: 'center',
    shadowColor: '#3B82F6',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 4,
  },
  buttonDisabled: {
    opacity: 0.5,
    shadowOpacity: 0,
  },
  buttonLabel: {
    color: 'white',
    fontSize: 18,
    fontWeight: '700',
  },
  currentValue: {
    marginTop: 32,
    padding: 20,
    borderRadius: 16,
    backgroundColor: '#EFF6FF',
    borderWidth: 1,
    borderColor: '#DBEAFE',
    alignItems: 'center',
  },
  currentValueLabel: {
    color: '#3B82F6',
    fontSize: 13,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  currentValueValue: {
    color: '#1E3A8A',
    fontSize: 32,
    fontWeight: '800',
    marginTop: 4,
  },
});

export default UserIdScreen;

