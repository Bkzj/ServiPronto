export type AdminTokenPayload = {
  sub: string;
  email: string;
  role: 'ADMIN';
};

export type SafeAdminProfile = {
  id: string;
  email: string;
  displayName: string;
  role: 'ADMIN';
  status: 'ACTIVE' | 'SUSPENDED';
};
