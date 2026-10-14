import {
  assertUploadAllowed,
  assertUploadedObject,
  newObjectKey,
  STORAGE_PREFIX,
} from './upload-policy';

const MB8 = 8 * 1024 * 1024;
const USER = '11111111-1111-4111-8111-111111111111';

describe('política de subida', () => {
  it('acepta JPEG, PNG y HEIC hasta 8 MB', () => {
    for (const type of ['image/jpeg', 'image/png', 'image/heic']) {
      expect(() => {
        assertUploadAllowed(type, MB8, MB8);
      }).not.toThrow();
    }
  });

  it('rechaza otros tipos, archivos vacíos y los de más de 8 MB', () => {
    expect(() => {
      assertUploadAllowed('application/pdf', 100, MB8);
    }).toThrow('Solo se aceptan fotos JPEG, PNG o HEIC.');
    expect(() => {
      assertUploadAllowed('image/jpeg', 0, MB8);
    }).toThrow('La foto está vacía.');
    expect(() => {
      assertUploadAllowed('image/jpeg', MB8 + 1, MB8);
    }).toThrow('La foto pesa más de 8 MB.');
  });

  it('genera claves impredecibles dentro del prefijo del usuario', () => {
    const a = newObjectKey(STORAGE_PREFIX.identity(USER), 'image/jpeg', 'ci_front');
    const b = newObjectKey(STORAGE_PREFIX.identity(USER), 'image/jpeg', 'ci_front');
    expect(a).toMatch(new RegExp(`^identity/${USER}/ci_front-[0-9a-f-]{36}\\.jpg$`));
    expect(a).not.toBe(b);
  });

  it('al confirmar exige que la clave sea del usuario y el objeto exista', () => {
    const prefix = STORAGE_PREFIX.identity(USER);
    const object = { sizeBytes: 1000, contentType: 'image/png' };
    expect(assertUploadedObject(`${prefix}x.png`, prefix, object, MB8)).toEqual({
      sizeBytes: 1000,
      contentType: 'image/png',
    });
    expect(() => assertUploadedObject('identity/otro-usuario/x.png', prefix, object, MB8)).toThrow(
      'Ese archivo no te pertenece.',
    );
    expect(() => assertUploadedObject(`${prefix}../../x.png`, prefix, object, MB8)).toThrow(
      'Ese archivo no te pertenece.',
    );
    expect(() => assertUploadedObject(`${prefix}x.png`, prefix, null, MB8)).toThrow(
      'No encontramos la foto. Vuelve a subirla.',
    );
    expect(() =>
      assertUploadedObject(
        `${prefix}x.png`,
        prefix,
        { sizeBytes: 10, contentType: 'text/html' },
        MB8,
      ),
    ).toThrow('Solo se aceptan fotos JPEG, PNG o HEIC.');
  });
});
