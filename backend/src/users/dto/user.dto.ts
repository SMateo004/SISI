import { ApiProperty } from '@nestjs/swagger';
import type { User } from '../../generated/prisma/client';

export class UserDto {
  @ApiProperty({ example: '7b0a1c7e-5f1e-4c41-9a51-0f8e7f1f5a10' })
  id!: string;

  @ApiProperty({ example: '+59170012345' })
  phone!: string;

  @ApiProperty({ example: 'María Pérez', nullable: true, type: String })
  name!: string | null;

  @ApiProperty({
    example: 'https://...firmada...',
    nullable: true,
    type: String,
    description: 'URL temporal de la foto de perfil',
  })
  photoUrl!: string | null;

  @ApiProperty({ enum: ['user', 'admin'], example: 'user' })
  role!: 'user' | 'admin';

  @ApiProperty({ enum: ['employer', 'worker'], example: 'employer' })
  activeMode!: 'employer' | 'worker';

  @ApiProperty({ example: 'b1f0e1a2-3c4d-4e5f-8a9b-0c1d2e3f4a5b' })
  cityId!: string;

  @ApiProperty({ example: '2026-10-14T12:00:00.000Z' })
  createdAt!: string;
}

export function toUserDto(user: User, photoUrl: string | null = null): UserDto {
  return {
    id: user.id,
    phone: user.phone,
    name: user.name,
    photoUrl,
    role: user.role,
    activeMode: user.activeMode,
    cityId: user.cityId,
    createdAt: user.createdAt.toISOString(),
  };
}
