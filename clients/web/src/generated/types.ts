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

export type CurrentUserVariables = {};

export type CurrentUserQuery = {
  __typename?: "Query";

  currentUser: Maybe<CurrentUserCurrentUser>;
};

export type CurrentUserCurrentUser = {
  __typename?: "User";

  email: string;

  id: string;

  name: Maybe<string>;

  organizations: CurrentUserOrganizations[];
};

export type CurrentUserOrganizations = {
  __typename?: "Organization";

  id: string;

  name: string;
};

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

  token: string;
};

export type GetPositionVariables = {
  id: string;
};

export type GetPositionQuery = {
  __typename?: "Query";

  position: Maybe<GetPositionPosition>;
};

export type GetPositionPosition = {
  __typename?: "Position";

  id: string;

  title: string;

  stages: GetPositionStages[];
};

export type GetPositionStages = {
  __typename?: "PositionStage";

  id: string;

  title: string;

  applicants: GetPositionApplicants[];
};

export type GetPositionApplicants = {
  __typename?: "Applicant";

  id: string;

  name: Maybe<string>;
};

export type ChangeApplicantStageVariables = {
  applicantId: string;
  positionStageId: string;
};

export type ChangeApplicantStageMutation = {
  __typename?: "Mutation";

  changeApplicantStage: Maybe<ChangeApplicantStageChangeApplicantStage>;
};

export type ChangeApplicantStageChangeApplicantStage = {
  __typename?: "ApplicantPayload";

  successful: boolean;
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

  id: string;

  title: string;
};
