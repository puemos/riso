export type Maybe<T> = T | null;

export interface ApplicantReviewInput {
  applicantId: string;

  kpiId: string;

  positionId: string;

  score?: Maybe<number>;
}

export interface OrganizationMemberInput {
  role?: Maybe<OrganizationMemebrRole>;
}

export interface PositionMemberInput {
  role?: Maybe<PositionMemebrRole>;
}

export interface PositionStageInput {
  title?: Maybe<string>;
}

export interface ChangePasswordInput {
  currentPassword?: Maybe<string>;

  password?: Maybe<string>;

  passwordConfirmation?: Maybe<string>;
}

export interface ConfirmAccountInput {
  code: string;

  email: string;
}

export interface ApplicantInput {
  name?: Maybe<string>;

  positionStageId: string;
}

export interface KpiInput {
  title?: Maybe<string>;
}

export interface OrganizationInput {
  name?: Maybe<string>;
}

export interface PositionInput {
  organizationId?: Maybe<string>;

  title?: Maybe<string>;
}

export interface ResendConfirmationInput {
  email: string;
}

export interface SignInInput {
  email?: Maybe<string>;

  password?: Maybe<string>;
}

export interface SignUpInput {
  email?: Maybe<string>;

  name?: Maybe<string>;

  password?: Maybe<string>;

  passwordConfirmation?: Maybe<string>;
}

export interface UpdateUserInput {
  email?: Maybe<string>;

  name?: Maybe<string>;
}
/** The organization member role */
export enum OrganizationMemebrRole {
  Editor = "EDITOR",
  Viewer = "VIEWER"
}
/** The position member role */
export enum PositionMemebrRole {
  Editor = "EDITOR",
  Viewer = "VIEWER"
}

/** The `DateTime` scalar type represents a date and time in the UTC timezone. The DateTime appears in a JSON response as an ISO8601 formatted string, including UTC timezone ("Z"). The parsed date and time string will be converted to UTC and any UTC offset other than 0 will be rejected. */
export type DateTime = any;

// ====================================================
// Documents
// ====================================================

export type SignInVariables = {
  input: SignInInput;
};

export type SignInMutation = {
  __typename?: "Mutation";

  signIn: Maybe<SignInSignIn>;
};

export type SignInSignIn = {
  __typename?: "SessionPayload";

  result: Maybe<SignInResult>;
};

export type SignInResult = {
  __typename?: "Session";

  token: Maybe<string>;
};

export type PositionsVariables = {
  keywords?: Maybe<string>;
};

export type PositionsQuery = {
  __typename?: "Query";

  positions: Maybe<PositionsPositions[]>;
};

export type PositionsPositions = {
  __typename?: "Position";

  id: Maybe<string>;

  title: Maybe<string>;
};
