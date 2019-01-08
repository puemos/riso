export type Maybe<T> = T | null;

export interface ApplicantReviewInput {
  applicantId: string;

  kpiId: string;

  positionId: string;

  score: number;
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
  name: string;

  positionId: string;
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
/** The position member role */
export enum PositionMemebrRole {
  Editor = "EDITOR",
  Viewer = "VIEWER"
}
/** The organization member role */
export enum OrganizationMemebrRole {
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

  name: string;

  organizations: CurrentUserOrganizations[];
};

export type CurrentUserOrganizations = {
  __typename?: "Organization";

  id: string;

  name: string;
};

export type GetApplicantVariables = {
  id: string;
};

export type GetApplicantQuery = {
  __typename?: "Query";

  applicant: Maybe<GetApplicantApplicant>;
};

export type GetApplicantApplicant = {
  __typename?: "Applicant";

  id: string;

  name: string;

  reviews: GetApplicantReviews[];

  position: Maybe<GetApplicantPosition>;

  stage: Maybe<GetApplicantStage>;
};

export type GetApplicantReviews = {
  __typename?: "Review";

  id: string;

  score: number;

  kpi: GetApplicantKpi;

  reviewer: GetApplicantReviewer;
};

export type GetApplicantKpi = {
  __typename?: "Kpi";

  title: string;
};

export type GetApplicantReviewer = {
  __typename?: "User";

  name: string;

  email: string;
};

export type GetApplicantPosition = {
  __typename?: "Position";

  id: string;

  title: string;

  kpis: GetApplicantKpis[];
};

export type GetApplicantKpis = {
  __typename?: "Kpi";

  id: string;

  title: string;
};

export type GetApplicantStage = {
  __typename?: "PositionStage";

  title: string;
};

export type CreateApplicantVariables = {
  input: ApplicantInput;
};

export type CreateApplicantMutation = {
  __typename?: "Mutation";

  createApplicant: Maybe<CreateApplicantCreateApplicant>;
};

export type CreateApplicantCreateApplicant = {
  __typename?: "ApplicantPayload";

  successful: boolean;
};

export type AddApplicantReviewVariables = {
  input: ApplicantReviewInput;
};

export type AddApplicantReviewMutation = {
  __typename?: "Mutation";

  addApplicantReview: Maybe<AddApplicantReviewAddApplicantReview>;
};

export type AddApplicantReviewAddApplicantReview = {
  __typename?: "ApplicantPayload";

  successful: boolean;
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

  applicants: GetPositionApplicants[];

  stages: GetPositionStages[];
};

export type GetPositionApplicants = {
  __typename?: "Applicant";

  id: string;

  name: string;

  photo: Maybe<string>;
};

export type GetPositionStages = {
  __typename?: "PositionStage";

  id: string;

  title: string;

  applicants: GetPosition_Applicants[];
};

export type GetPosition_Applicants = {
  __typename?: "Applicant";

  id: string;

  name: string;

  photo: Maybe<string>;
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

export type RemoveApplicantStageVariables = {
  applicantId: string;
};

export type RemoveApplicantStageMutation = {
  __typename?: "Mutation";

  removeApplicantStage: Maybe<RemoveApplicantStageRemoveApplicantStage>;
};

export type RemoveApplicantStageRemoveApplicantStage = {
  __typename?: "ApplicantPayload";

  successful: boolean;
};

export type GetCurrentUserOrgsVariables = {};

export type GetCurrentUserOrgsQuery = {
  __typename?: "Query";

  organizations: Maybe<GetCurrentUserOrgsOrganizations[]>;
};

export type GetCurrentUserOrgsOrganizations = {
  __typename?: "Organization";

  id: string;

  name: string;
};

export type CreatePositionVariables = {
  input: PositionInput;
};

export type CreatePositionMutation = {
  __typename?: "Mutation";

  createPosition: Maybe<CreatePositionCreatePosition>;
};

export type CreatePositionCreatePosition = {
  __typename?: "PositionPayload";

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

// ====================================================
// Scalars
// ====================================================

// ====================================================
// Types
// ====================================================

export interface RootQueryType {
  /** fetch a applicant by id */
  applicant?: Maybe<Applicant>;
  /** Fetch the current user */
  currentUser?: Maybe<User>;
  /** get kpis list */
  kpis?: Maybe<Kpi[]>;
  /** fetch a organization by id */
  organization?: Maybe<Organization>;
  /** get current user organizations list */
  organizations?: Maybe<Organization[]>;
  /** fetch a position by id */
  position?: Maybe<Position>;
  /** Position options for a field */
  positionOptions?: Maybe<Option[]>;
  /** get current user positions list */
  positions?: Maybe<Position[]>;
  /** Number of positions for current user */
  positionsCount?: Maybe<number>;
}

/** An applicant */
export interface Applicant {
  id: string;

  insertedAt: DateTime;

  name: string;

  photo?: Maybe<string>;

  position?: Maybe<Position>;

  reviews: Review[];

  stage?: Maybe<PositionStage>;
}

/** A position with title and content */
export interface Position {
  applicants: Applicant[];

  id: string;

  insertedAt: DateTime;

  kpis: Kpi[];

  members: PositionMember[];

  organization: Organization;

  stages: PositionStage[];

  title: string;
}

/** A kpi */
export interface Kpi {
  id: string;

  insertedAt: DateTime;

  title: string;
}

/** A memebr of a position */
export interface PositionMember {
  id: string;

  insertedAt: DateTime;

  role: PositionMemebrRole;

  user: User;
}

/** An user entry, returns basic user information */
export interface User {
  email: string;

  id: string;

  name: string;

  organizations: Organization[];

  positions: Position[];
}

/** A organization with name and content */
export interface Organization {
  id: string;

  insertedAt: DateTime;

  members: OrganizationMember[];

  name: string;

  positions: Position[];
}

/** A memebr of a organization */
export interface OrganizationMember {
  id: string;

  insertedAt: DateTime;

  role: OrganizationMemebrRole;

  user: User;
}

/** A stage of a position */
export interface PositionStage {
  applicants: Applicant[];

  id: string;

  insertedAt: DateTime;

  position: Position;

  title: string;
}

/** A review of applicant for a position kpi */
export interface Review {
  applicant: Applicant;

  id: string;

  insertedAt: DateTime;

  kpi: Kpi;

  position: Position;

  reviewer: User;

  score: number;
}

/** A option for select field in a form */
export interface Option {
  label?: Maybe<string>;

  value?: Maybe<string>;
}

export interface RootMutationType {
  /** Add an applicant review for a KPI */
  addApplicantReview?: Maybe<ApplicantPayload>;
  /** Add a member to a organization */
  addOrganizationMember?: Maybe<OrganizationMemberPayload>;
  /** Add a kpi to a position */
  addPositionKpi?: Maybe<PositionPayload>;
  /** Add a member to a position */
  addPositionMember?: Maybe<PositionMemberPayload>;
  /** Add a stage to a position */
  addPositionStage?: Maybe<PositionStagePayload>;
  /** Cancel Account */
  cancelAccount?: Maybe<boolean>;
  /** Change applicant position stage */
  changeApplicantStage?: Maybe<ApplicantPayload>;
  /** Change user password */
  changePassword?: Maybe<UserPayload>;
  /** confirm account */
  confirmAccount?: Maybe<SessionPayload>;
  /** Create an applicant */
  createApplicant?: Maybe<ApplicantPayload>;
  /** Create an kpi */
  createKpi?: Maybe<KpiPayload>;
  /** Create a organization */
  createOrganization?: Maybe<OrganizationPayload>;
  /** Create a position */
  createPosition?: Maybe<PositionPayload>;
  /** Destroy a Organization */
  deleteOrganization?: Maybe<OrganizationPayload>;
  /** Destroy a Position */
  deletePosition?: Maybe<PositionPayload>;
  /** Destroy a position stage */
  deletePositionStage?: Maybe<PositionStagePayload>;
  /** Remove applicant position stage */
  removeApplicantStage?: Maybe<ApplicantPayload>;
  /** Remove a kpi from a position */
  removePositionKpi?: Maybe<PositionPayload>;
  /** Resend confirmation */
  resendConfirmation?: Maybe<BooleanPayload>;
  /** Revoke token */
  revokeToken?: Maybe<boolean>;
  /** Sign in */
  signIn?: Maybe<SessionPayload>;
  /** Sign up */
  signUp?: Maybe<UserPayload>;
  /** Update a Organization and return Organization */
  updateOrganization?: Maybe<OrganizationPayload>;
  /** Update a Position and return Position */
  updatePosition?: Maybe<PositionPayload>;
  /** Update a position stage */
  updatePositionStage?: Maybe<PositionStagePayload>;
  /** Update current user profile */
  updateUser?: Maybe<UserPayload>;
}

export interface ApplicantPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<Applicant>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

/** Validation messages are returned when mutation input does not meet the requirements. While client-side validation is highly recommended to provide the best User Experience, All inputs will always be validated server-side. Some examples of validations are: * Username must be at least 10 characters * Email field does not contain an email address * Birth Date is required While GraphQL has support for required values, mutation data fields are always set to optional in our API. This allows 'required field' messages to be returned in the same manner as other validations. The only exceptions are id fields, which may be required to perform updates or deletes. */
export interface ValidationMessage {
  /** A unique error code for the type of validation used. TODO: Add list */
  code: string;
  /** The input field that the error applies to. The field can be used to identify which field the error message should be displayed next to in the presentation layer. If there are multiple errors to display for a field, multiple validation messages will be in the result. This field may be null in cases where an error cannot be applied to a specific field. */
  field?: Maybe<string>;
  /** A friendly error message, appropriate for display to the end user. The message is interpolated to include the appropriate variables. Example: `Username must be at least 10 characters` This message may change without notice, so we do not recommend you match against the text. Instead, use the *code* field for matching. */
  message?: Maybe<string>;
  /** A list of substitutions to be applied to a validation message template */
  options?: Maybe<ValidationOption[]>;
  /** A template used to generate the error message, with placeholders for option substiution. Example: `Username must be at least {count} characters` This message may change without notice, so we do not recommend you match against the text. Instead, use the *code* field for matching. */
  template?: Maybe<string>;
}

export interface ValidationOption {
  /** The name of a variable to be subsituted in a validation message template */
  key: string;
  /** The value of a variable to be substituted in a validation message template */
  value: string;
}

export interface OrganizationMemberPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<OrganizationMember>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface PositionPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<Position>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface PositionMemberPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<PositionMember>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface PositionStagePayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<PositionStage>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface UserPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<User>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface SessionPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<Session>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

/** token to authenticate user */
export interface Session {
  token: string;
}

export interface KpiPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<Kpi>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface OrganizationPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<Organization>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

export interface BooleanPayload {
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<ValidationMessage[]>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<boolean>;
  /** Indicates if the mutation completed successfully or not. */
  successful: boolean;
}

// ====================================================
// Arguments
// ====================================================

export interface ApplicantRootQueryTypeArgs {
  id: string;
}
export interface KpisRootQueryTypeArgs {
  keywords?: Maybe<string>;

  offset?: Maybe<number>;
}
export interface OrganizationRootQueryTypeArgs {
  id: string;
}
export interface OrganizationsRootQueryTypeArgs {
  keywords?: Maybe<string>;

  offset?: Maybe<number>;
}
export interface PositionRootQueryTypeArgs {
  id: string;
}
export interface PositionOptionsRootQueryTypeArgs {
  field: string;
}
export interface PositionsRootQueryTypeArgs {
  keywords?: Maybe<string>;

  offset?: Maybe<number>;
}
export interface PositionsCountRootQueryTypeArgs {
  keywords?: Maybe<string>;
}
export interface AddApplicantReviewRootMutationTypeArgs {
  input?: Maybe<ApplicantReviewInput>;
}
export interface AddOrganizationMemberRootMutationTypeArgs {
  input?: Maybe<OrganizationMemberInput>;

  memberEmail: string;

  organizationId: string;
}
export interface AddPositionKpiRootMutationTypeArgs {
  kpiId: string;

  positionId: string;
}
export interface AddPositionMemberRootMutationTypeArgs {
  input?: Maybe<PositionMemberInput>;

  memberEmail: string;

  positionId: string;
}
export interface AddPositionStageRootMutationTypeArgs {
  input?: Maybe<PositionStageInput>;

  positionId: string;
}
export interface ChangeApplicantStageRootMutationTypeArgs {
  applicantId?: Maybe<string>;

  positionStageId?: Maybe<string>;
}
export interface ChangePasswordRootMutationTypeArgs {
  input?: Maybe<ChangePasswordInput>;
}
export interface ConfirmAccountRootMutationTypeArgs {
  input?: Maybe<ConfirmAccountInput>;
}
export interface CreateApplicantRootMutationTypeArgs {
  input?: Maybe<ApplicantInput>;
}
export interface CreateKpiRootMutationTypeArgs {
  input?: Maybe<KpiInput>;
}
export interface CreateOrganizationRootMutationTypeArgs {
  input?: Maybe<OrganizationInput>;
}
export interface CreatePositionRootMutationTypeArgs {
  input?: Maybe<PositionInput>;
}
export interface DeleteOrganizationRootMutationTypeArgs {
  id: string;
}
export interface DeletePositionRootMutationTypeArgs {
  id: string;
}
export interface DeletePositionStageRootMutationTypeArgs {
  id: string;
}
export interface RemoveApplicantStageRootMutationTypeArgs {
  applicantId?: Maybe<string>;
}
export interface RemovePositionKpiRootMutationTypeArgs {
  kpiId: string;

  positionId: string;
}
export interface ResendConfirmationRootMutationTypeArgs {
  input?: Maybe<ResendConfirmationInput>;
}
export interface SignInRootMutationTypeArgs {
  input?: Maybe<SignInInput>;
}
export interface SignUpRootMutationTypeArgs {
  input?: Maybe<SignUpInput>;
}
export interface UpdateOrganizationRootMutationTypeArgs {
  id: string;

  input?: Maybe<OrganizationInput>;
}
export interface UpdatePositionRootMutationTypeArgs {
  id: string;

  input?: Maybe<PositionInput>;
}
export interface UpdatePositionStageRootMutationTypeArgs {
  id: string;

  input?: Maybe<PositionStageInput>;
}
export interface UpdateUserRootMutationTypeArgs {
  input?: Maybe<UpdateUserInput>;
}
