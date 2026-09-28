import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsDefined, IsObject, IsOptional, IsString, Matches, MaxLength, ValidateNested } from 'class-validator';

export class ClientAddressDto {
  @ApiProperty({ example: 'Belgrano', maxLength: 120, minLength: 1 })
  @IsDefined()
  @IsString()
  @Matches(/\S/)
  @MaxLength(120)
  street!: string;

  @ApiProperty({ example: '456', maxLength: 120, minLength: 1 })
  @IsDefined()
  @IsString()
  @Matches(/\S/)
  @MaxLength(120)
  number!: string;

  @ApiProperty({ example: 'Tandil', maxLength: 120, minLength: 1 })
  @IsDefined()
  @IsString()
  @Matches(/\S/)
  @MaxLength(120)
  city!: string;
}

export class ClientDraftDto {
  @ApiPropertyOptional({ example: 'Ana', maxLength: 120, minLength: 1 })
  @IsOptional()
  @IsString()
  @Matches(/\S/)
  @MaxLength(120)
  firstName?: string;

  @ApiPropertyOptional({ example: 'Pérez', maxLength: 120, minLength: 1 })
  @IsOptional()
  @IsString()
  @Matches(/\S/)
  @MaxLength(120)
  lastName?: string;

  @ApiPropertyOptional({ example: '1988-05-14', format: 'date' })
  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  birthDate?: string;

  @ApiPropertyOptional({ type: ClientAddressDto })
  @IsOptional()
  @IsObject()
  @ValidateNested()
  @Type(() => ClientAddressDto)
  address?: ClientAddressDto;
}

export class ClientProfileDto {
  @ApiProperty({ type: String, nullable: true, format: 'uuid', description: 'Null hasta guardar el primer paso' })
  id!: string | null;

  @ApiProperty({ type: String, nullable: true })
  firstName!: string | null;

  @ApiProperty({ type: String, nullable: true })
  lastName!: string | null;

  @ApiProperty({ type: String, nullable: true, format: 'date' })
  birthDate!: string | null;

  @ApiProperty({ type: ClientAddressDto, nullable: true })
  address!: ClientAddressDto | null;

  @ApiProperty({ format: 'email', readOnly: true, description: 'Correo de la identidad autenticada' })
  email!: string;

  @ApiProperty({ readOnly: true, description: 'Teléfono verificado de la identidad autenticada' })
  phone!: string;

  @ApiProperty({ readOnly: true, description: 'Todos los campos requeridos están completos' })
  isComplete!: boolean;
}
