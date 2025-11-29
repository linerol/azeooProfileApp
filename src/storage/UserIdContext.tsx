import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react';
import { clearUserId, persistUserId, readUserId } from './userPreferences';

type ContextValue = {
  userId: number | null;
  isHydrating: boolean;
  updateUserId: (nextId: number | null) => Promise<void>;
};

const UserIdContext = createContext<ContextValue | undefined>(undefined);

export const UserIdProvider = ({ children }: { children: React.ReactNode }) => {
  const [userId, setUserId] = useState<number | null>(null);
  const [isHydrating, setIsHydrating] = useState(true);

  useEffect(() => {
    let isMounted = true;

    const bootstrap = async () => {
      try {
        const storedUserId = await readUserId();
        if (isMounted) {
          setUserId(storedUserId);
        }
      } finally {
        if (isMounted) {
          setIsHydrating(false);
        }
      }
    };

    bootstrap();

    return () => {
      isMounted = false;
    };
  }, []);

  const updateUserId = useCallback(async (nextId: number | null) => {
    setUserId(nextId);

    if (nextId === null) {
      await clearUserId();
    } else {
      await persistUserId(nextId);
    }
  }, []);

  const value = useMemo(
    () => ({
      userId,
      isHydrating,
      updateUserId,
    }),
    [isHydrating, updateUserId, userId],
  );

  return <UserIdContext.Provider value={value}>{children}</UserIdContext.Provider>;
};

export const useUserId = () => {
  const context = useContext(UserIdContext);
  if (!context) {
    throw new Error('useUserId must be used within a UserIdProvider');
  }

  return context;
};

