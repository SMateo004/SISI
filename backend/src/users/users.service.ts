import {
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { Prisma, type User } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';

export interface VerifiedLogin {
  user: User;
  isNewUser: boolean;
}

@Injectable()
export class UsersService {
  constructor(
    private readonly prisma: PrismaService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  /**
   * Devuelve la cuenta del teléfono verificado o la crea (R1.1, R1.2).
   * Las cuentas nuevas quedan en modo employer y en la ciudad por defecto (R10.1).
   */
  async findOrCreateVerified(phone: string): Promise<VerifiedLogin> {
    const now = new Date();
    const existing = await this.prisma.user.findUnique({ where: { phone } });
    if (existing) {
      const user = existing.phoneVerifiedAt
        ? existing
        : await this.prisma.user.update({
            where: { id: existing.id },
            data: { phoneVerifiedAt: now },
          });
      return { user, isNewUser: false };
    }

    const cityId = await this.defaultCityId();
    try {
      const user = await this.prisma.user.create({
        data: { phone, cityId, phoneVerifiedAt: now },
      });
      return { user, isNewUser: true };
    } catch (error) {
      // Dos verificaciones simultáneas del mismo número: la otra ya creó la cuenta.
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        const user = await this.prisma.user.findUniqueOrThrow({ where: { phone } });
        return { user, isNewUser: false };
      }
      throw error;
    }
  }

  findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async getById(id: string): Promise<User> {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new NotFoundException('La cuenta no existe.');
    return user;
  }

  updateProfile(id: string, data: { name?: string; photoKey?: string }): Promise<User> {
    return this.prisma.user.update({ where: { id }, data });
  }

  private async defaultCityId(): Promise<string> {
    const slug = this.config.get('DEFAULT_CITY_SLUG', { infer: true });
    const city = await this.prisma.city.findUnique({ where: { slug }, select: { id: true } });
    if (!city) {
      throw new InternalServerErrorException(
        `La ciudad por defecto "${slug}" no existe. Ejecuta el seed (npm run prisma:seed).`,
      );
    }
    return city.id;
  }
}
