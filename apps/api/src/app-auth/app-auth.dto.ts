import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsEmail, IsString, IsUUID, Matches, MaxLength, MinLength } from 'class-validator';

export class AppLoginDto {
  @ApiProperty({ example: 'cliente@servipronto.test', format: 'email', maxLength: 254 })
  @Transform(({ value }: { value: unknown }) => typeof value === 'string' ? value.trim().toLowerCase() : value)
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @ApiProperty({ format: 'password', minLength: 12, maxLength: 128 })
  @IsString()
  @MinLength(12)
  @MaxLength(128)
  password!: string;
}

export class AppRegistrationDto extends AppLoginDto {
  @ApiProperty({ example: '+5492494000000', description: 'Teléfono en formato E.164', pattern: '^\\+[1-9]\\d{7,14}$' })
  @IsString()
  @Matches(/^\+[1-9]\d{7,14}$/)
  phone!: string;
}

export class AppVerificationDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('4')
  challengeId!: string;

  @ApiProperty({ pattern: '^\\d{6}$' })
  @IsString()
  @Matches(/^\d{6}$/)
  code!: string;
}

export class AppChallengeResponseDto {
  @ApiProperty({ format: 'uuid' })
  challengeId!: string;

  @ApiProperty({ format: 'date-time' })
  expiresAt!: Date;
}

export class AppProfileDto {
  @ApiProperty({ format: 'uuid' })
  id!: string;

  @ApiProperty({ format: 'email' })
  email!: string;

  @ApiProperty({ description: 'Teléfono verificado; solo aparece en una sesión válida' })
  phone!: string;
}

export class AppSessionResponseDto {
  @ApiProperty()
  accessToken!: string;

  @ApiProperty({ type: AppProfileDto })
  profile!: AppProfileDto;
}

export class AppErrorResponseDto {
  @ApiProperty()
  statusCode!: number;

  @ApiProperty()
  error!: string;

  @ApiProperty({ oneOf: [{ type: 'string' }, { type: 'array', items: { type: 'string' } }] })
  message!: string | string[];
}
