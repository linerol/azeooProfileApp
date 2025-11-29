import AsyncStorage from '@react-native-async-storage/async-storage';

const USER_ID_KEY = 'azeoo:userId';

export async function persistUserId(userId: number): Promise<void> {
  await AsyncStorage.setItem(USER_ID_KEY, userId.toString());
}

export async function readUserId(): Promise<number | null> {
  const rawValue = await AsyncStorage.getItem(USER_ID_KEY);
  if (!rawValue) {
    return null;
  }

  const parsed = Number(rawValue);
  return Number.isFinite(parsed) ? parsed : null;
}

export async function clearUserId(): Promise<void> {
  await AsyncStorage.removeItem(USER_ID_KEY);
}

