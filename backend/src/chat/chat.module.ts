import { Module } from '@nestjs/common';
import { ModerationModule } from '../moderation/moderation.module';
import { AdminChatController, ChatController } from './chat.controller';
import { ChatService } from './chat.service';

/** Chat del trabajo en la API (ADR-0031). La entrega la hace el worker. */
@Module({
  imports: [ModerationModule],
  controllers: [ChatController, AdminChatController],
  providers: [ChatService],
})
export class ChatModule {}
