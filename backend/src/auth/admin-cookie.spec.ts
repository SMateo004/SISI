import { adminCookieOptions, readCookie } from './admin-cookie';

describe('readCookie', () => {
  it('lee la cookie pedida entre varias', () => {
    expect(readCookie('a=1; sisi_admin_rt=abc.def; b=2', 'sisi_admin_rt')).toBe('abc.def');
  });

  it('decodifica el valor y tolera espacios', () => {
    expect(readCookie('  x = hola%20mundo ', 'x')).toBe('hola mundo');
  });

  it('devuelve undefined sin header, sin la cookie o con un valor mal codificado', () => {
    expect(readCookie(undefined, 'x')).toBeUndefined();
    expect(readCookie('y=1; sinvalor', 'x')).toBeUndefined();
    expect(readCookie('x=%E0%A4%A', 'x')).toBeUndefined();
  });

  it('no confunde un nombre que contiene al otro', () => {
    expect(readCookie('xsisi_admin_rt=malo; sisi_admin_rt=bueno', 'sisi_admin_rt')).toBe('bueno');
  });
});

describe('adminCookieOptions', () => {
  it('httpOnly, Secure, SameSite=Strict, con la ruta y la vida dadas', () => {
    expect(adminCookieOptions('/api/auth/admin', 600)).toEqual({
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      path: '/api/auth/admin',
      maxAge: 600_000,
    });
  });
});
