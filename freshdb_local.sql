PGDMP                         z            freshdb    9.5.25    9.5.25 ?              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false                       1262    213194    freshdb    DATABASE     y   CREATE DATABASE freshdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE freshdb;
             rai    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6                       0    0    SCHEMA public    ACL     ?   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        3079    12393    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                        0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            ?            1259    213203    ar_internal_metadata    TABLE     ?   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         rai    false    6            ?            1259    213328    audits    TABLE     ?  CREATE TABLE public.audits (
    id bigint NOT NULL,
    auditable_id integer,
    auditable_type character varying,
    associated_id integer,
    associated_type character varying,
    user_id integer,
    user_type character varying,
    username character varying,
    action character varying,
    audited_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    remote_address character varying,
    request_uuid character varying,
    created_at timestamp without time zone
);
    DROP TABLE public.audits;
       public         rai    false    6            ?            1259    213326    audits_id_seq    SEQUENCE     v   CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.audits_id_seq;
       public       rai    false    6    204            !           0    0    audits_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;
            public       rai    false    203            ?            1259    213872    beds    TABLE     Z  CREATE TABLE public.beds (
    id bigint NOT NULL,
    total_ward_beds bigint DEFAULT 0,
    occupied_ward_beds bigint DEFAULT 0,
    total_hdu_beds bigint DEFAULT 0,
    occupied_hdu_beds bigint DEFAULT 0,
    hospital_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.beds;
       public         rai    false    6            ?            1259    213870    beds_id_seq    SEQUENCE     t   CREATE SEQUENCE public.beds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.beds_id_seq;
       public       rai    false    252    6            "           0    0    beds_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.beds_id_seq OWNED BY public.beds.id;
            public       rai    false    251                       1259    213978    current_addresses    TABLE     ?  CREATE TABLE public.current_addresses (
    id bigint NOT NULL,
    district_id integer,
    district_name character varying,
    tehsil_id integer,
    tehsil_name character varying,
    uc_id integer,
    uc_name character varying,
    gp_dengue_patient_id integer,
    address text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    province_id integer
);
 %   DROP TABLE public.current_addresses;
       public         rai    false    6                       1259    213976    current_addresses_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.current_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.current_addresses_id_seq;
       public       rai    false    268    6            #           0    0    current_addresses_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.current_addresses_id_seq OWNED BY public.current_addresses.id;
            public       rai    false    267            ?            1259    213445    department_tags    TABLE     ?   CREATE TABLE public.department_tags (
    id bigint NOT NULL,
    department_id integer,
    tag_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 #   DROP TABLE public.department_tags;
       public         rai    false    6            ?            1259    213443    department_tags_id_seq    SEQUENCE        CREATE SEQUENCE public.department_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.department_tags_id_seq;
       public       rai    false    222    6            $           0    0    department_tags_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.department_tags_id_seq OWNED BY public.department_tags.id;
            public       rai    false    221            ?            1259    213295    departments    TABLE     ?   CREATE TABLE public.departments (
    id bigint NOT NULL,
    department_name character varying,
    department_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.departments;
       public         rai    false    6            ?            1259    213293    departments_id_seq    SEQUENCE     {   CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.departments_id_seq;
       public       rai    false    6    198            %           0    0    departments_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;
            public       rai    false    197            ?            1259    213251 	   districts    TABLE     &  CREATE TABLE public.districts (
    id bigint NOT NULL,
    district_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    province_id integer,
    division_id integer,
    division_name character varying
);
    DROP TABLE public.districts;
       public         rai    false    6            ?            1259    213249    districts_id_seq    SEQUENCE     y   CREATE SEQUENCE public.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.districts_id_seq;
       public       rai    false    190    6            &           0    0    districts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;
            public       rai    false    189            ?            1259    213317 	   divisions    TABLE     ?   CREATE TABLE public.divisions (
    id bigint NOT NULL,
    division_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    province_id integer
);
    DROP TABLE public.divisions;
       public         rai    false    6            ?            1259    213315    divisions_id_seq    SEQUENCE     y   CREATE SEQUENCE public.divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.divisions_id_seq;
       public       rai    false    202    6            '           0    0    divisions_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.divisions_id_seq OWNED BY public.divisions.id;
            public       rai    false    201                        1259    213906    gp_dengue_patients    TABLE     	  CREATE TABLE public.gp_dengue_patients (
    id bigint NOT NULL,
    gp_dengue_user_id integer,
    patient_name character varying,
    fh_name character varying,
    gender integer,
    age integer,
    age_month integer,
    dob character varying,
    contact_no character varying,
    provisional_diagnosis integer,
    lab_id integer,
    hospital_id integer,
    reffer_type integer,
    app_version character varying,
    activity_time timestamp without time zone,
    lat double precision,
    lng double precision,
    before_picture character varying,
    after_picture character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hospital_name character varying,
    cnic character varying
);
 &   DROP TABLE public.gp_dengue_patients;
       public         rai    false    6            ?            1259    213904    gp_dengue_patients_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.gp_dengue_patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.gp_dengue_patients_id_seq;
       public       rai    false    6    256            (           0    0    gp_dengue_patients_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.gp_dengue_patients_id_seq OWNED BY public.gp_dengue_patients.id;
            public       rai    false    255            ?            1259    213885    gp_dengue_users    TABLE     #  CREATE TABLE public.gp_dengue_users (
    id bigint NOT NULL,
    email character varying,
    password_digest character varying,
    name character varying,
    clinic_name character varying,
    contact_no character varying,
    pmdc_number character varying,
    role integer,
    district_id integer,
    district_name character varying,
    tehsil_id integer,
    tehsil_name character varying,
    uc_id integer,
    uc_name character varying,
    hospital_id integer,
    hospital_name character varying,
    address text,
    city_name character varying,
    lat character varying,
    lng character varying,
    status boolean DEFAULT true,
    is_logged_in boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 #   DROP TABLE public.gp_dengue_users;
       public         rai    false    6            ?            1259    213883    gp_dengue_users_id_seq    SEQUENCE        CREATE SEQUENCE public.gp_dengue_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.gp_dengue_users_id_seq;
       public       rai    false    6    254            )           0    0    gp_dengue_users_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.gp_dengue_users_id_seq OWNED BY public.gp_dengue_users.id;
            public       rai    false    253                       1259    213992    gp_forms    TABLE     ?  CREATE TABLE public.gp_forms (
    id bigint NOT NULL,
    gp_dengue_user_id integer,
    provisional_diagnosis integer,
    is_deleted boolean DEFAULT false,
    before_picture character varying,
    app_version character varying,
    activity_time timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.gp_forms;
       public         rai    false    6                       1259    213990    gp_forms_id_seq    SEQUENCE     x   CREATE SEQUENCE public.gp_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.gp_forms_id_seq;
       public       rai    false    6    270            *           0    0    gp_forms_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.gp_forms_id_seq OWNED BY public.gp_forms.id;
            public       rai    false    269            
           1259    213969    gp_lab_diagnostices    TABLE     ?  CREATE TABLE public.gp_lab_diagnostices (
    id bigint NOT NULL,
    ns1 integer,
    ns1_date date,
    pcr integer,
    pcr_date date,
    sero_type date,
    igm integer,
    igm_date date,
    igg integer,
    igg_date date,
    dengue_fever_type integer,
    gp_dengue_patient_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 '   DROP TABLE public.gp_lab_diagnostices;
       public         rai    false    6            	           1259    213967    gp_lab_diagnostices_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.gp_lab_diagnostices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.gp_lab_diagnostices_id_seq;
       public       rai    false    6    266            +           0    0    gp_lab_diagnostices_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.gp_lab_diagnostices_id_seq OWNED BY public.gp_lab_diagnostices.id;
            public       rai    false    265                       1259    213951    gp_lab_results    TABLE     ?  CREATE TABLE public.gp_lab_results (
    id bigint NOT NULL,
    hct_first_reading integer,
    hct_reading_date date,
    wbc_first_reading integer,
    wbc_reading_date date,
    platelet_first_reading integer,
    platelet_reading_date date,
    warning_sign integer,
    gp_dengue_patient_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 "   DROP TABLE public.gp_lab_results;
       public         rai    false    6                       1259    213949    gp_lab_results_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.gp_lab_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.gp_lab_results_id_seq;
       public       rai    false    6    262            ,           0    0    gp_lab_results_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.gp_lab_results_id_seq OWNED BY public.gp_lab_results.id;
            public       rai    false    261            ?            1259    213666    gp_patients    TABLE     3  CREATE TABLE public.gp_patients (
    id bigint NOT NULL,
    gp_user_id integer,
    reporting_date timestamp without time zone,
    patient_name character varying,
    fh_name character varying,
    dob character varying,
    age integer,
    age_month double precision,
    gender character varying,
    cnic character varying,
    phone_number character varying,
    district character varying,
    town_tehsil character varying,
    uc_name character varying,
    occupation character varying,
    lat character varying,
    long character varying,
    onset_date_fever date,
    prev_dengue_fever boolean,
    fever boolean,
    warning_signs boolean,
    provisional_diagnosis character varying,
    igg_performed character varying,
    igm_performed character varying,
    antigen_performed character varying,
    wbc_first_reading integer,
    wbc_first_date date,
    dengue_type character varying,
    diagnosis character varying,
    patient_status character varying,
    comments text,
    patient_type character varying,
    patient_condition character varying,
    street_no_name character varying,
    house_no character varying,
    viral_detection_performed character varying,
    hospital_name character varying,
    locality character varying,
    is_app_user boolean,
    residence_address character varying,
    workplace_address character varying,
    reffer_to character varying,
    symptoms character varying,
    platelets_reading character varying,
    platelets_date date,
    vitals character varying,
    headache boolean,
    retro_orbital_pain boolean,
    myalgia boolean,
    arthralgia_backache boolean,
    irritability_in_infants boolean,
    rash boolean,
    bleeding_manisfestations boolean,
    severe_abdominal_pain boolean,
    decreased_urinary_output boolean,
    temprature integer,
    hr integer,
    bp_s integer,
    bp_d integer,
    refered_to_confirmed character varying,
    probable_patient_status character varying,
    probable_comments character varying,
    present_address character varying,
    has_fever boolean,
    pp character varying,
    wbc1lessthan4000 boolean,
    platelets_less_than_lakh boolean,
    no_clinical_improvement boolean,
    persistent_vomiting boolean,
    lethargy_restlessness boolean,
    giddiness boolean,
    clammy_extremities boolean,
    bleeding_epistaxis boolean,
    hematemesis boolean,
    hct boolean,
    pulse_pressure boolean,
    no_urine_output boolean,
    ns1_reading_date date,
    detection_by_pcr character varying,
    pcr_detection_date date,
    igm_reading_date date,
    igg_reading_date date,
    df boolean,
    dhf boolean,
    dss boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    district_id integer,
    tehsil_id integer,
    uc_id integer,
    province_id integer
);
    DROP TABLE public.gp_patients;
       public         rai    false    6            ?            1259    213664    gp_patients_id_seq    SEQUENCE     {   CREATE SEQUENCE public.gp_patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.gp_patients_id_seq;
       public       rai    false    6    240            -           0    0    gp_patients_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.gp_patients_id_seq OWNED BY public.gp_patients.id;
            public       rai    false    239                       1259    213960    gp_symptoms    TABLE       CREATE TABLE public.gp_symptoms (
    id bigint NOT NULL,
    fever boolean,
    fever_date date,
    associate_symptom integer,
    gp_dengue_patient_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.gp_symptoms;
       public         rai    false    6                       1259    213958    gp_symptoms_id_seq    SEQUENCE     {   CREATE SEQUENCE public.gp_symptoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.gp_symptoms_id_seq;
       public       rai    false    264    6            .           0    0    gp_symptoms_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.gp_symptoms_id_seq OWNED BY public.gp_symptoms.id;
            public       rai    false    263            ?            1259    213647    gp_users    TABLE     ?  CREATE TABLE public.gp_users (
    id bigint NOT NULL,
    name character varying,
    clinic character varying,
    contact_no character varying,
    district character varying,
    address text,
    city_name character varying,
    division character varying,
    doctor_name character varying,
    email character varying,
    facility_type character varying,
    hospital character varying,
    is_mobile_signup boolean,
    lat character varying,
    lng character varying,
    password character varying,
    pmdc_number character varying,
    tehsil character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.gp_users;
       public         rai    false    6            ?            1259    213645    gp_users_id_seq    SEQUENCE     x   CREATE SEQUENCE public.gp_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.gp_users_id_seq;
       public       rai    false    238    6            /           0    0    gp_users_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.gp_users_id_seq OWNED BY public.gp_users.id;
            public       rai    false    237            ?            1259    213284 	   hospitals    TABLE     ?  CREATE TABLE public.hospitals (
    id bigint NOT NULL,
    hospital_name character varying,
    district_id integer,
    facility_type character varying,
    category character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    facility character varying,
    h_type integer DEFAULT 0,
    province_id integer
);
    DROP TABLE public.hospitals;
       public         rai    false    6            ?            1259    213282    hospitals_id_seq    SEQUENCE     y   CREATE SEQUENCE public.hospitals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.hospitals_id_seq;
       public       rai    false    6    196            0           0    0    hospitals_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;
            public       rai    false    195            ?            1259    213353    hotspots    TABLE     ?  CREATE TABLE public.hotspots (
    id bigint NOT NULL,
    tehsil character varying,
    uc character varying,
    address character varying,
    tag character varying,
    description character varying,
    hotspot_name character varying,
    lat character varying,
    long character varying,
    district_id integer,
    district character varying,
    is_active boolean,
    tehsil_id integer,
    uc_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tag_id integer,
    contact_no character varying,
    last_visited timestamp without time zone,
    is_tagged integer DEFAULT 0,
    hotspot_updated_by integer
);
    DROP TABLE public.hotspots;
       public         rai    false    6            ?            1259    213351    hotspots_id_seq    SEQUENCE     x   CREATE SEQUENCE public.hotspots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.hotspots_id_seq;
       public       rai    false    206    6            1           0    0    hotspots_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.hotspots_id_seq OWNED BY public.hotspots.id;
            public       rai    false    205                       1259    214060    insecticide_stocks    TABLE     ]  CREATE TABLE public.insecticide_stocks (
    id bigint NOT NULL,
    insecticide_name character varying,
    stock_received integer,
    stock_dispensed integer,
    stock_in_hand integer,
    district_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer
);
 &   DROP TABLE public.insecticide_stocks;
       public         rai    false    6                       1259    214058    insecticide_stocks_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.insecticide_stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.insecticide_stocks_id_seq;
       public       rai    false    6    278            2           0    0    insecticide_stocks_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.insecticide_stocks_id_seq OWNED BY public.insecticide_stocks.id;
            public       rai    false    277            ?            1259    213393    lab_patients    TABLE     ?	  CREATE TABLE public.lab_patients (
    id bigint NOT NULL,
    lab_name character varying,
    p_name character varying,
    fh_name character varying,
    gender character varying,
    occupation character varying,
    contact_no character varying,
    other_contact_no character varying,
    cnic character varying,
    cnic_type character varying,
    house_no character varying,
    street_no character varying,
    locality character varying,
    district_id integer,
    tehsil_id integer,
    uc_id integer,
    hct_first_reading integer,
    hct_first_reading_date date,
    wbc_first_reading double precision,
    wbc_first_reading_date date,
    platelet_first_reading integer,
    platelet_first_reading_date date,
    hct_second_reading integer,
    hct_second_reading_date date,
    wbc_second_reading double precision,
    wbc_second_reading_date date,
    platelet_second_reading character varying,
    platelet_second_reading_date date,
    hct_third_reading character varying,
    hct_third_reading_date date,
    wbc_third_reading double precision,
    wbc_third_reading_date date,
    platelet_third_reading character varying,
    platelet_third_reading_date date,
    ns_1 character varying,
    igg character varying,
    igm character varying,
    pcr character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    perm_house_no character varying,
    perm_street_no character varying,
    perm_locality character varying,
    perm_district_id integer,
    perm_tehsil_id integer,
    perm_uc_id integer,
    workplc_house_no character varying,
    workplc_street_no character varying,
    workplc_locality character varying,
    workplc_district_id integer,
    workplc_tehsil_id integer,
    workplc_uc_id integer,
    address text,
    perm_address text,
    workplc_address text,
    district character varying,
    tehsil character varying,
    uc character varying,
    perm_district character varying,
    perm_tehsil character varying,
    perm_uc character varying,
    workplc_district character varying,
    workplc_tehsil character varying,
    workplc_uc character varying,
    lab_id integer,
    age integer,
    month integer,
    provisional_diagnosis integer,
    is_dpc boolean DEFAULT false,
    transfer_type integer DEFAULT 0,
    reporting_date date,
    confirmation_date timestamp without time zone,
    comments text
);
     DROP TABLE public.lab_patients;
       public         rai    false    6            ?            1259    213391    lab_patients_id_seq    SEQUENCE     |   CREATE SEQUENCE public.lab_patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.lab_patients_id_seq;
       public       rai    false    212    6            3           0    0    lab_patients_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.lab_patients_id_seq OWNED BY public.lab_patients.id;
            public       rai    false    211            ?            1259    213240    lab_results    TABLE     ?  CREATE TABLE public.lab_results (
    id bigint NOT NULL,
    hct_first_reading integer,
    wbc_first_reading double precision,
    platelet_first_reading integer,
    hct_second_reading integer,
    wbc_second_reading double precision,
    platelet_second_reading integer,
    warning_signs boolean,
    ns1 character varying,
    pcr character varying,
    igm character varying,
    igg character varying,
    diagnosis character varying,
    dengue_virus_type character varying,
    patient_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hct_first_reading_date date,
    hct_second_reading_date date,
    hct_third_reading_date date,
    hct_third_reading integer,
    wbc_first_reading_date date,
    wbc_second_reading_date date,
    wbc_third_reading_date date,
    wbc_third_reading double precision,
    platelet_first_reading_date date,
    platelet_second_reading_date date,
    platelet_third_reading_date date,
    platelet_third_reading integer,
    lab_patient_id integer,
    advised_test text,
    report_ordering_date timestamp without time zone,
    report_receiving_date timestamp without time zone
);
    DROP TABLE public.lab_results;
       public         rai    false    6            ?            1259    213238    lab_results_id_seq    SEQUENCE     {   CREATE SEQUENCE public.lab_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.lab_results_id_seq;
       public       rai    false    6    188            4           0    0    lab_results_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.lab_results_id_seq OWNED BY public.lab_results.id;
            public       rai    false    187            ?            1259    213376    labs    TABLE     ?   CREATE TABLE public.labs (
    id bigint NOT NULL,
    lab_name character varying,
    district_id integer,
    lab_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.labs;
       public         rai    false    6            ?            1259    213374    labs_id_seq    SEQUENCE     t   CREATE SEQUENCE public.labs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.labs_id_seq;
       public       rai    false    6    210            5           0    0    labs_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.labs_id_seq OWNED BY public.labs.id;
            public       rai    false    209            ?            1259    213688    larvae_auditeds    TABLE     ?  CREATE TABLE public.larvae_auditeds (
    id bigint NOT NULL,
    mobile_user_id integer,
    app_version character varying,
    location character varying,
    lat character varying,
    lng character varying,
    larvae_found boolean,
    larvae_found_before boolean,
    larviciding boolean,
    remarks character varying,
    comments text,
    larviciding_type character varying,
    picture_url text,
    simple_activity_id integer,
    visited_before integer,
    visit_adjacent_house character varying,
    chemical_option character varying,
    larvaciding_conducted integer,
    mechanical_option character varying,
    biological_selected integer,
    larva_found_from character varying,
    chemical_selected integer,
    awareenss_session character varying,
    mechanical_selected integer,
    last_visited character varying,
    supervisor_visited character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 #   DROP TABLE public.larvae_auditeds;
       public         rai    false    6            ?            1259    213686    larvae_auditeds_id_seq    SEQUENCE        CREATE SEQUENCE public.larvae_auditeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.larvae_auditeds_id_seq;
       public       rai    false    244    6            6           0    0    larvae_auditeds_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.larvae_auditeds_id_seq OWNED BY public.larvae_auditeds.id;
            public       rai    false    243            ?            1259    213811    legacy_activities    TABLE       CREATE TABLE public.legacy_activities (
    id bigint NOT NULL,
    count integer,
    district_id integer,
    department_id integer,
    act_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 %   DROP TABLE public.legacy_activities;
       public         rai    false    6            ?            1259    213809    legacy_activities_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.legacy_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.legacy_activities_id_seq;
       public       rai    false    6    250            7           0    0    legacy_activities_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.legacy_activities_id_seq OWNED BY public.legacy_activities.id;
            public       rai    false    249                       1259    214030    medicine_stocks    TABLE     W  CREATE TABLE public.medicine_stocks (
    id bigint NOT NULL,
    medicine_name character varying,
    stock_received integer,
    stock_dispensed integer,
    stock_in_hand integer,
    hospital_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer
);
 #   DROP TABLE public.medicine_stocks;
       public         rai    false    6                       1259    214028    medicine_stocks_id_seq    SEQUENCE        CREATE SEQUENCE public.medicine_stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.medicine_stocks_id_seq;
       public       rai    false    6    272            8           0    0    medicine_stocks_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.medicine_stocks_id_seq OWNED BY public.medicine_stocks.id;
            public       rai    false    271            ?            1259    213609    mobile_user_tehsils    TABLE     ?   CREATE TABLE public.mobile_user_tehsils (
    id bigint NOT NULL,
    tehsil_id integer,
    mobile_user_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 '   DROP TABLE public.mobile_user_tehsils;
       public         rai    false    6            ?            1259    213607    mobile_user_tehsils_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.mobile_user_tehsils_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.mobile_user_tehsils_id_seq;
       public       rai    false    234    6            9           0    0    mobile_user_tehsils_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.mobile_user_tehsils_id_seq OWNED BY public.mobile_user_tehsils.id;
            public       rai    false    233            ?            1259    213404    mobile_users    TABLE       CREATE TABLE public.mobile_users (
    id bigint NOT NULL,
    username character varying,
    password_digest character varying,
    role character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    is_logged_in boolean,
    tehsil character varying,
    tehsil_id integer,
    district character varying,
    district_id integer,
    uc character varying,
    uc_id integer,
    department_id integer,
    status boolean,
    is_forgot boolean DEFAULT false
);
     DROP TABLE public.mobile_users;
       public         rai    false    6            ?            1259    213402    mobile_users_id_seq    SEQUENCE     |   CREATE SEQUENCE public.mobile_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mobile_users_id_seq;
       public       rai    false    214    6            :           0    0    mobile_users_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.mobile_users_id_seq OWNED BY public.mobile_users.id;
            public       rai    false    213            ?            1259    213465    patient_activities    TABLE     [  CREATE TABLE public.patient_activities (
    id bigint NOT NULL,
    tag_category_id integer,
    tag_category_name character varying,
    awareness boolean,
    removal_bleeding_spot boolean,
    elimination_bleeding_spot boolean,
    patient_spray boolean,
    comment text,
    tag_name character varying,
    tag_id integer,
    app_version integer,
    latitude character varying,
    longitude character varying,
    activity_time timestamp without time zone,
    os_version_number integer,
    os_version_name character varying,
    user_id integer,
    patient_id integer,
    uc_name character varying,
    uc_id integer,
    tehsil_name character varying,
    tehsil_id integer,
    before_picture character varying,
    after_picture character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    patient_place integer,
    department_id integer,
    department_name character varying,
    district_id integer,
    district_name character varying,
    provisional_diagnosis integer,
    description text,
    province_id integer
);
 &   DROP TABLE public.patient_activities;
       public         rai    false    6            ?            1259    213463    patient_activities_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.patient_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.patient_activities_id_seq;
       public       rai    false    226    6            ;           0    0    patient_activities_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.patient_activities_id_seq OWNED BY public.patient_activities.id;
            public       rai    false    225            ?            1259    213677    patient_auditeds    TABLE     ?  CREATE TABLE public.patient_auditeds (
    id bigint NOT NULL,
    mobile_user_id integer,
    app_version character varying,
    location character varying,
    lat character varying,
    lng character varying,
    conduction_place boolean,
    sop_followed boolean,
    response_conducted_at_place boolean,
    comments character varying,
    picture_url text,
    patient_activity_id integer,
    visited_before integer,
    visit_adjacent_house character varying,
    chemical_option character varying,
    larvaciding_conducted integer,
    mechanical_option character varying,
    biological_selected integer,
    larva_found_from character varying,
    chemical_selected integer,
    awareenss_session character varying,
    mechanical_selected integer,
    last_visited character varying,
    supervisor_visited character varying,
    larvae_found boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 $   DROP TABLE public.patient_auditeds;
       public         rai    false    6            ?            1259    213675    patient_auditeds_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.patient_auditeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.patient_auditeds_id_seq;
       public       rai    false    6    242            <           0    0    patient_auditeds_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.patient_auditeds_id_seq OWNED BY public.patient_auditeds.id;
            public       rai    false    241            ?            1259    213229    patients    TABLE     ?
  CREATE TABLE public.patients (
    id bigint NOT NULL,
    patient_name character varying,
    fh_name character varying,
    age integer,
    age_month integer,
    gender character varying,
    cnic character varying,
    cnic_relation character varying,
    patient_contact character varying,
    relation_contact character varying,
    address text,
    district character varying,
    district_id integer,
    tehsil character varying,
    tehsil_id integer,
    uc character varying,
    uc_id integer,
    permanent_address text,
    permanent_district character varying,
    permanent_district_id integer,
    permanent_tehsil character varying,
    permanent_tehsil_id integer,
    permanent_uc character varying,
    permanent_uc_id integer,
    workplace_address text,
    workplace_district character varying,
    workplace_district_id integer,
    workplace_tehsil character varying,
    workplace_tehsil_id integer,
    workplace_uc character varying,
    workplace_uc_id integer,
    date_of_onset date,
    fever_last_till date,
    fever boolean,
    previous_dengue_fever boolean,
    associated_symptom boolean,
    provisional_diagnosis integer,
    other_diagnosed_fever character varying,
    patient_status integer,
    patient_outcome integer,
    patient_condition integer,
    hospital character varying,
    hospital_id integer,
    user_id integer,
    username character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reporting_date date,
    active_status boolean DEFAULT true,
    referred_to_id integer,
    referred_to character varying,
    referred_from_id integer,
    referred_reason character varying,
    currently_referred boolean,
    is_released boolean,
    residence_tagged boolean,
    workplace_tagged boolean,
    permanent_residence_tagged boolean,
    residence_count integer DEFAULT 0,
    permanent_count integer DEFAULT 0,
    workplace_count integer DEFAULT 0,
    is_residence_household boolean DEFAULT false,
    is_permanent_household boolean DEFAULT false,
    is_workplace_household boolean DEFAULT false,
    is_dpc boolean DEFAULT false,
    transfer_type integer DEFAULT 0,
    lab_patient_id integer,
    deleted_at timestamp without time zone,
    confirmation_date timestamp without time zone,
    comments text,
    lab_user_id integer,
    lab_user_name character varying,
    updated_id integer,
    death_date date,
    admission_date date,
    lama_date date,
    discharge_date date,
    lab_id integer,
    lab_name character varying,
    entered_by integer DEFAULT 0,
    province_id integer,
    confirmation_id integer,
    confirmation_role integer,
    p_search_type integer DEFAULT 0,
    passport character varying
);
    DROP TABLE public.patients;
       public         rai    false    6            ?            1259    213227    patients_id_seq    SEQUENCE     x   CREATE SEQUENCE public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.patients_id_seq;
       public       rai    false    6    186            =           0    0    patients_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;
            public       rai    false    185                       1259    214052    pcr_machines    TABLE     7  CREATE TABLE public.pcr_machines (
    id bigint NOT NULL,
    pcr_functional integer,
    pcr_non_functional integer,
    total_pcr_machines integer,
    hospital_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer
);
     DROP TABLE public.pcr_machines;
       public         rai    false    6                       1259    214050    pcr_machines_id_seq    SEQUENCE     |   CREATE SEQUENCE public.pcr_machines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.pcr_machines_id_seq;
       public       rai    false    6    276            >           0    0    pcr_machines_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.pcr_machines_id_seq OWNED BY public.pcr_machines.id;
            public       rai    false    275                       1259    213921    permanent_addresses    TABLE     ?  CREATE TABLE public.permanent_addresses (
    id bigint NOT NULL,
    district_id integer,
    district_name character varying,
    tehsil_id integer,
    tehsil_name character varying,
    uc_id integer,
    uc_name character varying,
    gp_dengue_patient_id integer,
    address text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 '   DROP TABLE public.permanent_addresses;
       public         rai    false    6                       1259    213919    permanent_addresses_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.permanent_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.permanent_addresses_id_seq;
       public       rai    false    258    6            ?           0    0    permanent_addresses_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.permanent_addresses_id_seq OWNED BY public.permanent_addresses.id;
            public       rai    false    257            ?            1259    213494    pictures    TABLE     _  CREATE TABLE public.pictures (
    id bigint NOT NULL,
    before_picture character varying,
    after_picture character varying,
    pictureable_id integer,
    pictureable_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pictureable_tag character varying
);
    DROP TABLE public.pictures;
       public         rai    false    6            ?            1259    213492    pictures_id_seq    SEQUENCE     x   CREATE SEQUENCE public.pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.pictures_id_seq;
       public       rai    false    230    6            @           0    0    pictures_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.pictures_id_seq OWNED BY public.pictures.id;
            public       rai    false    229                       1259    214041 
   ppe_stocks    TABLE     M  CREATE TABLE public.ppe_stocks (
    id bigint NOT NULL,
    ppe_name character varying,
    stock_received integer,
    stock_dispensed integer,
    stock_in_hand integer,
    hospital_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer
);
    DROP TABLE public.ppe_stocks;
       public         rai    false    6                       1259    214039    ppe_stocks_id_seq    SEQUENCE     z   CREATE SEQUENCE public.ppe_stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.ppe_stocks_id_seq;
       public       rai    false    274    6            A           0    0    ppe_stocks_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.ppe_stocks_id_seq OWNED BY public.ppe_stocks.id;
            public       rai    false    273            ?            1259    213306 	   provinces    TABLE     ?   CREATE TABLE public.provinces (
    id bigint NOT NULL,
    province_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.provinces;
       public         rai    false    6            ?            1259    213304    provinces_id_seq    SEQUENCE     y   CREATE SEQUENCE public.provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.provinces_id_seq;
       public       rai    false    200    6            B           0    0    provinces_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.provinces_id_seq OWNED BY public.provinces.id;
            public       rai    false    199            ?            1259    213195    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         rai    false    6            ?            1259    213479    simple_activities    TABLE     ?  CREATE TABLE public.simple_activities (
    id bigint NOT NULL,
    tag_category_id integer,
    tag_category_name character varying,
    larva_found boolean,
    larva_type integer,
    io_action integer,
    removal_water_stagnant boolean,
    removal_garbage boolean,
    removal_rof_top_cleaned boolean,
    old_record_sorted boolean,
    sops_follow boolean,
    comment text,
    tag_name character varying,
    tag_id integer,
    app_version integer,
    latitude character varying,
    longitude character varying,
    activity_time timestamp without time zone,
    os_version_number integer,
    os_version_name character varying,
    user_id integer,
    hotspot_id integer,
    tehsil_id integer,
    tehsil_name character varying,
    uc_name character varying,
    uc_id integer,
    before_picture character varying,
    after_picture character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    department_id integer,
    department_name character varying,
    district_id integer,
    district_name character varying,
    description text,
    is_bogus boolean,
    province_id integer
);
 %   DROP TABLE public.simple_activities;
       public         rai    false    6            ?            1259    213477    simple_activities_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.simple_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.simple_activities_id_seq;
       public       rai    false    228    6            C           0    0    simple_activities_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.simple_activities_id_seq OWNED BY public.simple_activities.id;
            public       rai    false    227            ?            1259    213754 
   slideshows    TABLE     @  CREATE TABLE public.slideshows (
    id bigint NOT NULL,
    name character varying,
    activity_type integer,
    user_id integer,
    activity_ids text[] DEFAULT '{}'::text[],
    department_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.slideshows;
       public         rai    false    6            ?            1259    213752    slideshows_id_seq    SEQUENCE     z   CREATE SEQUENCE public.slideshows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.slideshows_id_seq;
       public       rai    false    248    6            D           0    0    slideshows_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.slideshows_id_seq OWNED BY public.slideshows.id;
            public       rai    false    247            ?            1259    213699    surveillance_audits    TABLE     ?  CREATE TABLE public.surveillance_audits (
    id bigint NOT NULL,
    mobile_user_id integer,
    app_version character varying,
    location character varying,
    lat double precision,
    lng double precision,
    no_of_containers_checked integer,
    remarks text,
    visited_before boolean,
    simple_activity_id integer,
    rooftop_checked boolean,
    material_provided boolean,
    is_indoor boolean,
    larvae_found_earlier integer,
    larvae_found boolean,
    time_taken integer,
    picture_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 '   DROP TABLE public.surveillance_audits;
       public         rai    false    6            ?            1259    213697    surveillance_audits_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.surveillance_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.surveillance_audits_id_seq;
       public       rai    false    246    6            E           0    0    surveillance_audits_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.surveillance_audits_id_seq OWNED BY public.surveillance_audits.id;
            public       rai    false    245            ?            1259    213426    tag_categories    TABLE     3  CREATE TABLE public.tag_categories (
    id bigint NOT NULL,
    category_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    urdu character varying,
    m_category_id integer,
    category_name_en character varying
);
 "   DROP TABLE public.tag_categories;
       public         rai    false    6            ?            1259    213424    tag_categories_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.tag_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tag_categories_id_seq;
       public       rai    false    6    218            F           0    0    tag_categories_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.tag_categories_id_seq OWNED BY public.tag_categories.id;
            public       rai    false    217            ?            1259    213415    tag_options    TABLE     ?   CREATE TABLE public.tag_options (
    id bigint NOT NULL,
    option_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    m_option_id integer
);
    DROP TABLE public.tag_options;
       public         rai    false    6            ?            1259    213413    tag_options_id_seq    SEQUENCE     {   CREATE SEQUENCE public.tag_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.tag_options_id_seq;
       public       rai    false    6    216            G           0    0    tag_options_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.tag_options_id_seq OWNED BY public.tag_options.id;
            public       rai    false    215            ?            1259    213364    tags    TABLE     ?  CREATE TABLE public.tags (
    id bigint NOT NULL,
    tag_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tag_category_id integer,
    tag_image_url character varying,
    tag_options character varying,
    urdu character varying,
    m_tag_id integer,
    m_category_id integer,
    tag_name_en character varying
);
    DROP TABLE public.tags;
       public         rai    false    6            ?            1259    213362    tags_id_seq    SEQUENCE     t   CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       rai    false    208    6            H           0    0    tags_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;
            public       rai    false    207            ?            1259    213262    tehsils    TABLE     ?   CREATE TABLE public.tehsils (
    id bigint NOT NULL,
    tehsil_name character varying,
    district_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.tehsils;
       public         rai    false    6            ?            1259    213260    tehsils_id_seq    SEQUENCE     w   CREATE SEQUENCE public.tehsils_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.tehsils_id_seq;
       public       rai    false    6    192            I           0    0    tehsils_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.tehsils_id_seq OWNED BY public.tehsils.id;
            public       rai    false    191                       1259    214081 	   test_logs    TABLE     ?  CREATE TABLE public.test_logs (
    id bigint NOT NULL,
    hct_first_reading integer,
    hct_first_reading_date date,
    wbc_first_reading double precision,
    wbc_first_reading_date date,
    platelet_first_reading integer,
    platelet_first_reading_date date,
    hct_second_reading integer,
    hct_second_reading_date date,
    wbc_second_reading double precision,
    wbc_second_reading_date date,
    platelet_second_reading character varying,
    platelet_second_reading_date date,
    hct_third_reading character varying,
    hct_third_reading_date date,
    wbc_third_reading double precision,
    wbc_third_reading_date date,
    platelet_third_reading character varying,
    platelet_third_reading_date date,
    ns1 character varying,
    igg character varying,
    igm character varying,
    pcr character varying,
    provisional_diagnosis character varying,
    change_by character varying,
    reporting_date date,
    comments text,
    patient_name character varying,
    cnic character varying,
    patient_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    passport character varying
);
    DROP TABLE public.test_logs;
       public         rai    false    6                       1259    214079    test_logs_id_seq    SEQUENCE     y   CREATE SEQUENCE public.test_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.test_logs_id_seq;
       public       rai    false    6    280            J           0    0    test_logs_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.test_logs_id_seq OWNED BY public.test_logs.id;
            public       rai    false    279            ?            1259    213619 
   tpv_audits    TABLE     ?  CREATE TABLE public.tpv_audits (
    id bigint NOT NULL,
    department_id integer,
    department_name character varying,
    tehsil_id integer,
    tehsil_name character varying,
    audit_date date,
    district_id integer,
    district_name character varying,
    activity_ids text,
    category_name character varying,
    audit_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    activity_type integer DEFAULT 0
);
    DROP TABLE public.tpv_audits;
       public         rai    false    6            ?            1259    213617    tpv_audits_id_seq    SEQUENCE     z   CREATE SEQUENCE public.tpv_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tpv_audits_id_seq;
       public       rai    false    236    6            K           0    0    tpv_audits_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.tpv_audits_id_seq OWNED BY public.tpv_audits.id;
            public       rai    false    235            ?            1259    213453    u_towns    TABLE     <  CREATE TABLE public.u_towns (
    id bigint NOT NULL,
    name character varying,
    townable_id integer,
    townable_type character varying,
    tehsil_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tehsil_name character varying
);
    DROP TABLE public.u_towns;
       public         rai    false    6            ?            1259    213451    u_towns_id_seq    SEQUENCE     w   CREATE SEQUENCE public.u_towns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.u_towns_id_seq;
       public       rai    false    6    224            L           0    0    u_towns_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.u_towns_id_seq OWNED BY public.u_towns.id;
            public       rai    false    223            ?            1259    213273    ucs    TABLE       CREATE TABLE public.ucs (
    id bigint NOT NULL,
    uc_name character varying,
    district_id integer,
    tehsil_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    province_id integer
);
    DROP TABLE public.ucs;
       public         rai    false    6            ?            1259    213271 
   ucs_id_seq    SEQUENCE     s   CREATE SEQUENCE public.ucs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.ucs_id_seq;
       public       rai    false    194    6            M           0    0 
   ucs_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.ucs_id_seq OWNED BY public.ucs.id;
            public       rai    false    193            ?            1259    213437    user_categories    TABLE     ?   CREATE TABLE public.user_categories (
    id bigint NOT NULL,
    mobile_user_id integer,
    tag_category_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 #   DROP TABLE public.user_categories;
       public         rai    false    6            ?            1259    213435    user_categories_id_seq    SEQUENCE        CREATE SEQUENCE public.user_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.user_categories_id_seq;
       public       rai    false    6    220            N           0    0    user_categories_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.user_categories_id_seq OWNED BY public.user_categories.id;
            public       rai    false    219            ?            1259    213213    users    TABLE       CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    username character varying,
    sub_role character varying,
    lab_id integer,
    role integer,
    district_id integer,
    hospital_id integer,
    department_id integer,
    tehsil_id integer,
    is_forgot boolean DEFAULT false,
    status boolean DEFAULT true,
    old_user_id integer,
    hotspot_status boolean
);
    DROP TABLE public.users;
       public         rai    false    6            ?            1259    213211    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       rai    false    6    184            O           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
            public       rai    false    183                       1259    213936    workplace_addresses    TABLE     ?  CREATE TABLE public.workplace_addresses (
    id bigint NOT NULL,
    district_id integer,
    district_name character varying,
    tehsil_id integer,
    tehsil_name character varying,
    uc_id integer,
    uc_name character varying,
    gp_dengue_patient_id integer,
    address text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 '   DROP TABLE public.workplace_addresses;
       public         rai    false    6                       1259    213934    workplace_addresses_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.workplace_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.workplace_addresses_id_seq;
       public       rai    false    260    6            P           0    0    workplace_addresses_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.workplace_addresses_id_seq OWNED BY public.workplace_addresses.id;
            public       rai    false    259            ?            1259    213594    zero_patients    TABLE     ?  CREATE TABLE public.zero_patients (
    id bigint NOT NULL,
    user_id integer,
    hospital_id integer,
    hospital character varying,
    district_id integer,
    district character varying,
    t_type integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lab_id integer,
    lab character varying,
    province_id integer
);
 !   DROP TABLE public.zero_patients;
       public         rai    false    6            ?            1259    213592    zero_patients_id_seq    SEQUENCE     }   CREATE SEQUENCE public.zero_patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.zero_patients_id_seq;
       public       rai    false    232    6            Q           0    0    zero_patients_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.zero_patients_id_seq OWNED BY public.zero_patients.id;
            public       rai    false    231            M	           2604    213331    id    DEFAULT     f   ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);
 8   ALTER TABLE public.audits ALTER COLUMN id DROP DEFAULT;
       public       rai    false    204    203    204            m	           2604    213875    id    DEFAULT     b   ALTER TABLE ONLY public.beds ALTER COLUMN id SET DEFAULT nextval('public.beds_id_seq'::regclass);
 6   ALTER TABLE public.beds ALTER COLUMN id DROP DEFAULT;
       public       rai    false    251    252    252            {	           2604    213981    id    DEFAULT     |   ALTER TABLE ONLY public.current_addresses ALTER COLUMN id SET DEFAULT nextval('public.current_addresses_id_seq'::regclass);
 C   ALTER TABLE public.current_addresses ALTER COLUMN id DROP DEFAULT;
       public       rai    false    267    268    268            [	           2604    213448    id    DEFAULT     x   ALTER TABLE ONLY public.department_tags ALTER COLUMN id SET DEFAULT nextval('public.department_tags_id_seq'::regclass);
 A   ALTER TABLE public.department_tags ALTER COLUMN id DROP DEFAULT;
       public       rai    false    221    222    222            J	           2604    213298    id    DEFAULT     p   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public       rai    false    197    198    198            E	           2604    213254    id    DEFAULT     l   ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);
 ;   ALTER TABLE public.districts ALTER COLUMN id DROP DEFAULT;
       public       rai    false    190    189    190            L	           2604    213320    id    DEFAULT     l   ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);
 ;   ALTER TABLE public.divisions ALTER COLUMN id DROP DEFAULT;
       public       rai    false    202    201    202            u	           2604    213909    id    DEFAULT     ~   ALTER TABLE ONLY public.gp_dengue_patients ALTER COLUMN id SET DEFAULT nextval('public.gp_dengue_patients_id_seq'::regclass);
 D   ALTER TABLE public.gp_dengue_patients ALTER COLUMN id DROP DEFAULT;
       public       rai    false    256    255    256            r	           2604    213888    id    DEFAULT     x   ALTER TABLE ONLY public.gp_dengue_users ALTER COLUMN id SET DEFAULT nextval('public.gp_dengue_users_id_seq'::regclass);
 A   ALTER TABLE public.gp_dengue_users ALTER COLUMN id DROP DEFAULT;
       public       rai    false    253    254    254            |	           2604    213995    id    DEFAULT     j   ALTER TABLE ONLY public.gp_forms ALTER COLUMN id SET DEFAULT nextval('public.gp_forms_id_seq'::regclass);
 :   ALTER TABLE public.gp_forms ALTER COLUMN id DROP DEFAULT;
       public       rai    false    269    270    270            z	           2604    213972    id    DEFAULT     ?   ALTER TABLE ONLY public.gp_lab_diagnostices ALTER COLUMN id SET DEFAULT nextval('public.gp_lab_diagnostices_id_seq'::regclass);
 E   ALTER TABLE public.gp_lab_diagnostices ALTER COLUMN id DROP DEFAULT;
       public       rai    false    265    266    266            x	           2604    213954    id    DEFAULT     v   ALTER TABLE ONLY public.gp_lab_results ALTER COLUMN id SET DEFAULT nextval('public.gp_lab_results_id_seq'::regclass);
 @   ALTER TABLE public.gp_lab_results ALTER COLUMN id DROP DEFAULT;
       public       rai    false    262    261    262            f	           2604    213669    id    DEFAULT     p   ALTER TABLE ONLY public.gp_patients ALTER COLUMN id SET DEFAULT nextval('public.gp_patients_id_seq'::regclass);
 =   ALTER TABLE public.gp_patients ALTER COLUMN id DROP DEFAULT;
       public       rai    false    239    240    240            y	           2604    213963    id    DEFAULT     p   ALTER TABLE ONLY public.gp_symptoms ALTER COLUMN id SET DEFAULT nextval('public.gp_symptoms_id_seq'::regclass);
 =   ALTER TABLE public.gp_symptoms ALTER COLUMN id DROP DEFAULT;
       public       rai    false    264    263    264            e	           2604    213650    id    DEFAULT     j   ALTER TABLE ONLY public.gp_users ALTER COLUMN id SET DEFAULT nextval('public.gp_users_id_seq'::regclass);
 :   ALTER TABLE public.gp_users ALTER COLUMN id DROP DEFAULT;
       public       rai    false    237    238    238            H	           2604    213287    id    DEFAULT     l   ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);
 ;   ALTER TABLE public.hospitals ALTER COLUMN id DROP DEFAULT;
       public       rai    false    196    195    196            O	           2604    213356    id    DEFAULT     j   ALTER TABLE ONLY public.hotspots ALTER COLUMN id SET DEFAULT nextval('public.hotspots_id_seq'::regclass);
 :   ALTER TABLE public.hotspots ALTER COLUMN id DROP DEFAULT;
       public       rai    false    205    206    206            ?	           2604    214063    id    DEFAULT     ~   ALTER TABLE ONLY public.insecticide_stocks ALTER COLUMN id SET DEFAULT nextval('public.insecticide_stocks_id_seq'::regclass);
 D   ALTER TABLE public.insecticide_stocks ALTER COLUMN id DROP DEFAULT;
       public       rai    false    277    278    278            S	           2604    213396    id    DEFAULT     r   ALTER TABLE ONLY public.lab_patients ALTER COLUMN id SET DEFAULT nextval('public.lab_patients_id_seq'::regclass);
 >   ALTER TABLE public.lab_patients ALTER COLUMN id DROP DEFAULT;
       public       rai    false    212    211    212            D	           2604    213243    id    DEFAULT     p   ALTER TABLE ONLY public.lab_results ALTER COLUMN id SET DEFAULT nextval('public.lab_results_id_seq'::regclass);
 =   ALTER TABLE public.lab_results ALTER COLUMN id DROP DEFAULT;
       public       rai    false    187    188    188            R	           2604    213379    id    DEFAULT     b   ALTER TABLE ONLY public.labs ALTER COLUMN id SET DEFAULT nextval('public.labs_id_seq'::regclass);
 6   ALTER TABLE public.labs ALTER COLUMN id DROP DEFAULT;
       public       rai    false    210    209    210            h	           2604    213691    id    DEFAULT     x   ALTER TABLE ONLY public.larvae_auditeds ALTER COLUMN id SET DEFAULT nextval('public.larvae_auditeds_id_seq'::regclass);
 A   ALTER TABLE public.larvae_auditeds ALTER COLUMN id DROP DEFAULT;
       public       rai    false    244    243    244            l	           2604    213814    id    DEFAULT     |   ALTER TABLE ONLY public.legacy_activities ALTER COLUMN id SET DEFAULT nextval('public.legacy_activities_id_seq'::regclass);
 C   ALTER TABLE public.legacy_activities ALTER COLUMN id DROP DEFAULT;
       public       rai    false    250    249    250            ~	           2604    214033    id    DEFAULT     x   ALTER TABLE ONLY public.medicine_stocks ALTER COLUMN id SET DEFAULT nextval('public.medicine_stocks_id_seq'::regclass);
 A   ALTER TABLE public.medicine_stocks ALTER COLUMN id DROP DEFAULT;
       public       rai    false    272    271    272            b	           2604    213612    id    DEFAULT     ?   ALTER TABLE ONLY public.mobile_user_tehsils ALTER COLUMN id SET DEFAULT nextval('public.mobile_user_tehsils_id_seq'::regclass);
 E   ALTER TABLE public.mobile_user_tehsils ALTER COLUMN id DROP DEFAULT;
       public       rai    false    234    233    234            V	           2604    213407    id    DEFAULT     r   ALTER TABLE ONLY public.mobile_users ALTER COLUMN id SET DEFAULT nextval('public.mobile_users_id_seq'::regclass);
 >   ALTER TABLE public.mobile_users ALTER COLUMN id DROP DEFAULT;
       public       rai    false    213    214    214            ]	           2604    213468    id    DEFAULT     ~   ALTER TABLE ONLY public.patient_activities ALTER COLUMN id SET DEFAULT nextval('public.patient_activities_id_seq'::regclass);
 D   ALTER TABLE public.patient_activities ALTER COLUMN id DROP DEFAULT;
       public       rai    false    225    226    226            g	           2604    213680    id    DEFAULT     z   ALTER TABLE ONLY public.patient_auditeds ALTER COLUMN id SET DEFAULT nextval('public.patient_auditeds_id_seq'::regclass);
 B   ALTER TABLE public.patient_auditeds ALTER COLUMN id DROP DEFAULT;
       public       rai    false    242    241    242            8	           2604    213232    id    DEFAULT     j   ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);
 :   ALTER TABLE public.patients ALTER COLUMN id DROP DEFAULT;
       public       rai    false    185    186    186            ?	           2604    214055    id    DEFAULT     r   ALTER TABLE ONLY public.pcr_machines ALTER COLUMN id SET DEFAULT nextval('public.pcr_machines_id_seq'::regclass);
 >   ALTER TABLE public.pcr_machines ALTER COLUMN id DROP DEFAULT;
       public       rai    false    275    276    276            v	           2604    213924    id    DEFAULT     ?   ALTER TABLE ONLY public.permanent_addresses ALTER COLUMN id SET DEFAULT nextval('public.permanent_addresses_id_seq'::regclass);
 E   ALTER TABLE public.permanent_addresses ALTER COLUMN id DROP DEFAULT;
       public       rai    false    257    258    258            _	           2604    213497    id    DEFAULT     j   ALTER TABLE ONLY public.pictures ALTER COLUMN id SET DEFAULT nextval('public.pictures_id_seq'::regclass);
 :   ALTER TABLE public.pictures ALTER COLUMN id DROP DEFAULT;
       public       rai    false    230    229    230            	           2604    214044    id    DEFAULT     n   ALTER TABLE ONLY public.ppe_stocks ALTER COLUMN id SET DEFAULT nextval('public.ppe_stocks_id_seq'::regclass);
 <   ALTER TABLE public.ppe_stocks ALTER COLUMN id DROP DEFAULT;
       public       rai    false    274    273    274            K	           2604    213309    id    DEFAULT     l   ALTER TABLE ONLY public.provinces ALTER COLUMN id SET DEFAULT nextval('public.provinces_id_seq'::regclass);
 ;   ALTER TABLE public.provinces ALTER COLUMN id DROP DEFAULT;
       public       rai    false    200    199    200            ^	           2604    213482    id    DEFAULT     |   ALTER TABLE ONLY public.simple_activities ALTER COLUMN id SET DEFAULT nextval('public.simple_activities_id_seq'::regclass);
 C   ALTER TABLE public.simple_activities ALTER COLUMN id DROP DEFAULT;
       public       rai    false    227    228    228            j	           2604    213757    id    DEFAULT     n   ALTER TABLE ONLY public.slideshows ALTER COLUMN id SET DEFAULT nextval('public.slideshows_id_seq'::regclass);
 <   ALTER TABLE public.slideshows ALTER COLUMN id DROP DEFAULT;
       public       rai    false    247    248    248            i	           2604    213702    id    DEFAULT     ?   ALTER TABLE ONLY public.surveillance_audits ALTER COLUMN id SET DEFAULT nextval('public.surveillance_audits_id_seq'::regclass);
 E   ALTER TABLE public.surveillance_audits ALTER COLUMN id DROP DEFAULT;
       public       rai    false    245    246    246            Y	           2604    213429    id    DEFAULT     v   ALTER TABLE ONLY public.tag_categories ALTER COLUMN id SET DEFAULT nextval('public.tag_categories_id_seq'::regclass);
 @   ALTER TABLE public.tag_categories ALTER COLUMN id DROP DEFAULT;
       public       rai    false    217    218    218            X	           2604    213418    id    DEFAULT     p   ALTER TABLE ONLY public.tag_options ALTER COLUMN id SET DEFAULT nextval('public.tag_options_id_seq'::regclass);
 =   ALTER TABLE public.tag_options ALTER COLUMN id DROP DEFAULT;
       public       rai    false    216    215    216            Q	           2604    213367    id    DEFAULT     b   ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       rai    false    207    208    208            F	           2604    213265    id    DEFAULT     h   ALTER TABLE ONLY public.tehsils ALTER COLUMN id SET DEFAULT nextval('public.tehsils_id_seq'::regclass);
 9   ALTER TABLE public.tehsils ALTER COLUMN id DROP DEFAULT;
       public       rai    false    192    191    192            ?	           2604    214084    id    DEFAULT     l   ALTER TABLE ONLY public.test_logs ALTER COLUMN id SET DEFAULT nextval('public.test_logs_id_seq'::regclass);
 ;   ALTER TABLE public.test_logs ALTER COLUMN id DROP DEFAULT;
       public       rai    false    280    279    280            c	           2604    213622    id    DEFAULT     n   ALTER TABLE ONLY public.tpv_audits ALTER COLUMN id SET DEFAULT nextval('public.tpv_audits_id_seq'::regclass);
 <   ALTER TABLE public.tpv_audits ALTER COLUMN id DROP DEFAULT;
       public       rai    false    236    235    236            \	           2604    213456    id    DEFAULT     h   ALTER TABLE ONLY public.u_towns ALTER COLUMN id SET DEFAULT nextval('public.u_towns_id_seq'::regclass);
 9   ALTER TABLE public.u_towns ALTER COLUMN id DROP DEFAULT;
       public       rai    false    223    224    224            G	           2604    213276    id    DEFAULT     `   ALTER TABLE ONLY public.ucs ALTER COLUMN id SET DEFAULT nextval('public.ucs_id_seq'::regclass);
 5   ALTER TABLE public.ucs ALTER COLUMN id DROP DEFAULT;
       public       rai    false    193    194    194            Z	           2604    213440    id    DEFAULT     x   ALTER TABLE ONLY public.user_categories ALTER COLUMN id SET DEFAULT nextval('public.user_categories_id_seq'::regclass);
 A   ALTER TABLE public.user_categories ALTER COLUMN id DROP DEFAULT;
       public       rai    false    219    220    220            3	           2604    213216    id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       rai    false    184    183    184            w	           2604    213939    id    DEFAULT     ?   ALTER TABLE ONLY public.workplace_addresses ALTER COLUMN id SET DEFAULT nextval('public.workplace_addresses_id_seq'::regclass);
 E   ALTER TABLE public.workplace_addresses ALTER COLUMN id DROP DEFAULT;
       public       rai    false    260    259    260            `	           2604    213597    id    DEFAULT     t   ALTER TABLE ONLY public.zero_patients ALTER COLUMN id SET DEFAULT nextval('public.zero_patients_id_seq'::regclass);
 ?   ALTER TABLE public.zero_patients ALTER COLUMN id DROP DEFAULT;
       public       rai    false    231    232    232            ?
          0    213203    ar_internal_metadata 
   TABLE DATA               R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       rai    false    182   -b      ?
          0    213328    audits 
   TABLE DATA               ?   COPY public.audits (id, auditable_id, auditable_type, associated_id, associated_type, user_id, user_type, username, action, audited_changes, version, comment, remote_address, request_uuid, created_at) FROM stdin;
    public       rai    false    204   |b      R           0    0    audits_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.audits_id_seq', 3, true);
            public       rai    false    203            ?
          0    213872    beds 
   TABLE DATA               ?   COPY public.beds (id, total_ward_beds, occupied_ward_beds, total_hdu_beds, occupied_hdu_beds, hospital_id, created_at, updated_at) FROM stdin;
    public       rai    false    252   h      S           0    0    beds_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.beds_id_seq', 2, true);
            public       rai    false    251                      0    213978    current_addresses 
   TABLE DATA               ?   COPY public.current_addresses (id, district_id, district_name, tehsil_id, tehsil_name, uc_id, uc_name, gp_dengue_patient_id, address, created_at, updated_at, province_id) FROM stdin;
    public       rai    false    268   sh      T           0    0    current_addresses_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.current_addresses_id_seq', 1, false);
            public       rai    false    267            ?
          0    213445    department_tags 
   TABLE DATA               \   COPY public.department_tags (id, department_id, tag_id, created_at, updated_at) FROM stdin;
    public       rai    false    222   ?h      U           0    0    department_tags_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.department_tags_id_seq', 5, true);
            public       rai    false    221            ?
          0    213295    departments 
   TABLE DATA               c   COPY public.departments (id, department_name, department_type, created_at, updated_at) FROM stdin;
    public       rai    false    198   ?h      V           0    0    departments_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.departments_id_seq', 1, true);
            public       rai    false    197            ?
          0    213251 	   districts 
   TABLE DATA               w   COPY public.districts (id, district_name, created_at, updated_at, province_id, division_id, division_name) FROM stdin;
    public       rai    false    190   >i      W           0    0    districts_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.districts_id_seq', 4, true);
            public       rai    false    189            ?
          0    213317 	   divisions 
   TABLE DATA               [   COPY public.divisions (id, division_name, created_at, updated_at, province_id) FROM stdin;
    public       rai    false    202   ?i      X           0    0    divisions_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.divisions_id_seq', 9, true);
            public       rai    false    201            ?
          0    213906    gp_dengue_patients 
   TABLE DATA               .  COPY public.gp_dengue_patients (id, gp_dengue_user_id, patient_name, fh_name, gender, age, age_month, dob, contact_no, provisional_diagnosis, lab_id, hospital_id, reffer_type, app_version, activity_time, lat, lng, before_picture, after_picture, created_at, updated_at, hospital_name, cnic) FROM stdin;
    public       rai    false    256   ?j      Y           0    0    gp_dengue_patients_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.gp_dengue_patients_id_seq', 1, false);
            public       rai    false    255            ?
          0    213885    gp_dengue_users 
   TABLE DATA               #  COPY public.gp_dengue_users (id, email, password_digest, name, clinic_name, contact_no, pmdc_number, role, district_id, district_name, tehsil_id, tehsil_name, uc_id, uc_name, hospital_id, hospital_name, address, city_name, lat, lng, status, is_logged_in, created_at, updated_at) FROM stdin;
    public       rai    false    254   k      Z           0    0    gp_dengue_users_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.gp_dengue_users_id_seq', 1, true);
            public       rai    false    253                      0    213992    gp_forms 
   TABLE DATA               ?   COPY public.gp_forms (id, gp_dengue_user_id, provisional_diagnosis, is_deleted, before_picture, app_version, activity_time, created_at, updated_at) FROM stdin;
    public       rai    false    270   l      [           0    0    gp_forms_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.gp_forms_id_seq', 1, false);
            public       rai    false    269            	          0    213969    gp_lab_diagnostices 
   TABLE DATA               ?   COPY public.gp_lab_diagnostices (id, ns1, ns1_date, pcr, pcr_date, sero_type, igm, igm_date, igg, igg_date, dengue_fever_type, gp_dengue_patient_id, created_at, updated_at) FROM stdin;
    public       rai    false    266   8l      \           0    0    gp_lab_diagnostices_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.gp_lab_diagnostices_id_seq', 1, false);
            public       rai    false    265                      0    213951    gp_lab_results 
   TABLE DATA               ?   COPY public.gp_lab_results (id, hct_first_reading, hct_reading_date, wbc_first_reading, wbc_reading_date, platelet_first_reading, platelet_reading_date, warning_sign, gp_dengue_patient_id, created_at, updated_at) FROM stdin;
    public       rai    false    262   Ul      ]           0    0    gp_lab_results_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.gp_lab_results_id_seq', 1, false);
            public       rai    false    261            ?
          0    213666    gp_patients 
   TABLE DATA               '  COPY public.gp_patients (id, gp_user_id, reporting_date, patient_name, fh_name, dob, age, age_month, gender, cnic, phone_number, district, town_tehsil, uc_name, occupation, lat, long, onset_date_fever, prev_dengue_fever, fever, warning_signs, provisional_diagnosis, igg_performed, igm_performed, antigen_performed, wbc_first_reading, wbc_first_date, dengue_type, diagnosis, patient_status, comments, patient_type, patient_condition, street_no_name, house_no, viral_detection_performed, hospital_name, locality, is_app_user, residence_address, workplace_address, reffer_to, symptoms, platelets_reading, platelets_date, vitals, headache, retro_orbital_pain, myalgia, arthralgia_backache, irritability_in_infants, rash, bleeding_manisfestations, severe_abdominal_pain, decreased_urinary_output, temprature, hr, bp_s, bp_d, refered_to_confirmed, probable_patient_status, probable_comments, present_address, has_fever, pp, wbc1lessthan4000, platelets_less_than_lakh, no_clinical_improvement, persistent_vomiting, lethargy_restlessness, giddiness, clammy_extremities, bleeding_epistaxis, hematemesis, hct, pulse_pressure, no_urine_output, ns1_reading_date, detection_by_pcr, pcr_detection_date, igm_reading_date, igg_reading_date, df, dhf, dss, created_at, updated_at, district_id, tehsil_id, uc_id, province_id) FROM stdin;
    public       rai    false    240   rl      ^           0    0    gp_patients_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.gp_patients_id_seq', 1, false);
            public       rai    false    239                      0    213960    gp_symptoms 
   TABLE DATA               }   COPY public.gp_symptoms (id, fever, fever_date, associate_symptom, gp_dengue_patient_id, created_at, updated_at) FROM stdin;
    public       rai    false    264   ?l      _           0    0    gp_symptoms_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.gp_symptoms_id_seq', 1, false);
            public       rai    false    263            ?
          0    213647    gp_users 
   TABLE DATA               ?   COPY public.gp_users (id, name, clinic, contact_no, district, address, city_name, division, doctor_name, email, facility_type, hospital, is_mobile_signup, lat, lng, password, pmdc_number, tehsil, created_at, updated_at) FROM stdin;
    public       rai    false    238   ?l      `           0    0    gp_users_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.gp_users_id_seq', 1, false);
            public       rai    false    237            ?
          0    213284 	   hospitals 
   TABLE DATA               ?   COPY public.hospitals (id, hospital_name, district_id, facility_type, category, created_at, updated_at, facility, h_type, province_id) FROM stdin;
    public       rai    false    196   ?l      a           0    0    hospitals_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.hospitals_id_seq', 2, true);
            public       rai    false    195            ?
          0    213353    hotspots 
   TABLE DATA               ?   COPY public.hotspots (id, tehsil, uc, address, tag, description, hotspot_name, lat, long, district_id, district, is_active, tehsil_id, uc_id, created_at, updated_at, tag_id, contact_no, last_visited, is_tagged, hotspot_updated_by) FROM stdin;
    public       rai    false    206   Im      b           0    0    hotspots_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.hotspots_id_seq', 2, true);
            public       rai    false    205                      0    214060    insecticide_stocks 
   TABLE DATA               ?   COPY public.insecticide_stocks (id, insecticide_name, stock_received, stock_dispensed, stock_in_hand, district_id, created_at, updated_at, user_id) FROM stdin;
    public       rai    false    278   0n      c           0    0    insecticide_stocks_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.insecticide_stocks_id_seq', 1, false);
            public       rai    false    277            ?
          0    213393    lab_patients 
   TABLE DATA               d  COPY public.lab_patients (id, lab_name, p_name, fh_name, gender, occupation, contact_no, other_contact_no, cnic, cnic_type, house_no, street_no, locality, district_id, tehsil_id, uc_id, hct_first_reading, hct_first_reading_date, wbc_first_reading, wbc_first_reading_date, platelet_first_reading, platelet_first_reading_date, hct_second_reading, hct_second_reading_date, wbc_second_reading, wbc_second_reading_date, platelet_second_reading, platelet_second_reading_date, hct_third_reading, hct_third_reading_date, wbc_third_reading, wbc_third_reading_date, platelet_third_reading, platelet_third_reading_date, ns_1, igg, igm, pcr, created_at, updated_at, perm_house_no, perm_street_no, perm_locality, perm_district_id, perm_tehsil_id, perm_uc_id, workplc_house_no, workplc_street_no, workplc_locality, workplc_district_id, workplc_tehsil_id, workplc_uc_id, address, perm_address, workplc_address, district, tehsil, uc, perm_district, perm_tehsil, perm_uc, workplc_district, workplc_tehsil, workplc_uc, lab_id, age, month, provisional_diagnosis, is_dpc, transfer_type, reporting_date, confirmation_date, comments) FROM stdin;
    public       rai    false    212   Mn      d           0    0    lab_patients_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.lab_patients_id_seq', 1, false);
            public       rai    false    211            ?
          0    213240    lab_results 
   TABLE DATA               ?  COPY public.lab_results (id, hct_first_reading, wbc_first_reading, platelet_first_reading, hct_second_reading, wbc_second_reading, platelet_second_reading, warning_signs, ns1, pcr, igm, igg, diagnosis, dengue_virus_type, patient_id, created_at, updated_at, hct_first_reading_date, hct_second_reading_date, hct_third_reading_date, hct_third_reading, wbc_first_reading_date, wbc_second_reading_date, wbc_third_reading_date, wbc_third_reading, platelet_first_reading_date, platelet_second_reading_date, platelet_third_reading_date, platelet_third_reading, lab_patient_id, advised_test, report_ordering_date, report_receiving_date) FROM stdin;
    public       rai    false    188   jn      e           0    0    lab_results_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.lab_results_id_seq', 2, true);
            public       rai    false    187            ?
          0    213376    labs 
   TABLE DATA               [   COPY public.labs (id, lab_name, district_id, lab_type, created_at, updated_at) FROM stdin;
    public       rai    false    210   ?n      f           0    0    labs_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.labs_id_seq', 1, false);
            public       rai    false    209            ?
          0    213688    larvae_auditeds 
   TABLE DATA               ?  COPY public.larvae_auditeds (id, mobile_user_id, app_version, location, lat, lng, larvae_found, larvae_found_before, larviciding, remarks, comments, larviciding_type, picture_url, simple_activity_id, visited_before, visit_adjacent_house, chemical_option, larvaciding_conducted, mechanical_option, biological_selected, larva_found_from, chemical_selected, awareenss_session, mechanical_selected, last_visited, supervisor_visited, created_at, updated_at) FROM stdin;
    public       rai    false    244   o      g           0    0    larvae_auditeds_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.larvae_auditeds_id_seq', 1, false);
            public       rai    false    243            ?
          0    213811    legacy_activities 
   TABLE DATA               t   COPY public.legacy_activities (id, count, district_id, department_id, act_date, created_at, updated_at) FROM stdin;
    public       rai    false    250   o      h           0    0    legacy_activities_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.legacy_activities_id_seq', 1, false);
            public       rai    false    249                      0    214030    medicine_stocks 
   TABLE DATA               ?   COPY public.medicine_stocks (id, medicine_name, stock_received, stock_dispensed, stock_in_hand, hospital_id, created_at, updated_at, user_id) FROM stdin;
    public       rai    false    272   ;o      i           0    0    medicine_stocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.medicine_stocks_id_seq', 1, true);
            public       rai    false    271            ?
          0    213609    mobile_user_tehsils 
   TABLE DATA               d   COPY public.mobile_user_tehsils (id, tehsil_id, mobile_user_id, created_at, updated_at) FROM stdin;
    public       rai    false    234   ?o      j           0    0    mobile_user_tehsils_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.mobile_user_tehsils_id_seq', 1, true);
            public       rai    false    233            ?
          0    213404    mobile_users 
   TABLE DATA               ?   COPY public.mobile_users (id, username, password_digest, role, created_at, updated_at, is_logged_in, tehsil, tehsil_id, district, district_id, uc, uc_id, department_id, status, is_forgot) FROM stdin;
    public       rai    false    214   ?o      k           0    0    mobile_users_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.mobile_users_id_seq', 1, true);
            public       rai    false    213            ?
          0    213465    patient_activities 
   TABLE DATA                  COPY public.patient_activities (id, tag_category_id, tag_category_name, awareness, removal_bleeding_spot, elimination_bleeding_spot, patient_spray, comment, tag_name, tag_id, app_version, latitude, longitude, activity_time, os_version_number, os_version_name, user_id, patient_id, uc_name, uc_id, tehsil_name, tehsil_id, before_picture, after_picture, created_at, updated_at, patient_place, department_id, department_name, district_id, district_name, provisional_diagnosis, description, province_id) FROM stdin;
    public       rai    false    226   sp      l           0    0    patient_activities_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.patient_activities_id_seq', 1, false);
            public       rai    false    225            ?
          0    213677    patient_auditeds 
   TABLE DATA               ?  COPY public.patient_auditeds (id, mobile_user_id, app_version, location, lat, lng, conduction_place, sop_followed, response_conducted_at_place, comments, picture_url, patient_activity_id, visited_before, visit_adjacent_house, chemical_option, larvaciding_conducted, mechanical_option, biological_selected, larva_found_from, chemical_selected, awareenss_session, mechanical_selected, last_visited, supervisor_visited, larvae_found, created_at, updated_at) FROM stdin;
    public       rai    false    242   ?p      m           0    0    patient_auditeds_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.patient_auditeds_id_seq', 1, false);
            public       rai    false    241            ?
          0    213229    patients 
   TABLE DATA                 COPY public.patients (id, patient_name, fh_name, age, age_month, gender, cnic, cnic_relation, patient_contact, relation_contact, address, district, district_id, tehsil, tehsil_id, uc, uc_id, permanent_address, permanent_district, permanent_district_id, permanent_tehsil, permanent_tehsil_id, permanent_uc, permanent_uc_id, workplace_address, workplace_district, workplace_district_id, workplace_tehsil, workplace_tehsil_id, workplace_uc, workplace_uc_id, date_of_onset, fever_last_till, fever, previous_dengue_fever, associated_symptom, provisional_diagnosis, other_diagnosed_fever, patient_status, patient_outcome, patient_condition, hospital, hospital_id, user_id, username, created_at, updated_at, reporting_date, active_status, referred_to_id, referred_to, referred_from_id, referred_reason, currently_referred, is_released, residence_tagged, workplace_tagged, permanent_residence_tagged, residence_count, permanent_count, workplace_count, is_residence_household, is_permanent_household, is_workplace_household, is_dpc, transfer_type, lab_patient_id, deleted_at, confirmation_date, comments, lab_user_id, lab_user_name, updated_id, death_date, admission_date, lama_date, discharge_date, lab_id, lab_name, entered_by, province_id, confirmation_id, confirmation_role, p_search_type, passport) FROM stdin;
    public       rai    false    186   ?p      n           0    0    patients_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.patients_id_seq', 2, true);
            public       rai    false    185                      0    214052    pcr_machines 
   TABLE DATA               ?   COPY public.pcr_machines (id, pcr_functional, pcr_non_functional, total_pcr_machines, hospital_id, created_at, updated_at, user_id) FROM stdin;
    public       rai    false    276   
r      o           0    0    pcr_machines_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.pcr_machines_id_seq', 1, true);
            public       rai    false    275                      0    213921    permanent_addresses 
   TABLE DATA               ?   COPY public.permanent_addresses (id, district_id, district_name, tehsil_id, tehsil_name, uc_id, uc_name, gp_dengue_patient_id, address, created_at, updated_at) FROM stdin;
    public       rai    false    258   Lr      p           0    0    permanent_addresses_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.permanent_addresses_id_seq', 1, false);
            public       rai    false    257            ?
          0    213494    pictures 
   TABLE DATA               ?   COPY public.pictures (id, before_picture, after_picture, pictureable_id, pictureable_type, created_at, updated_at, pictureable_tag) FROM stdin;
    public       rai    false    230   ir      q           0    0    pictures_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.pictures_id_seq', 9, true);
            public       rai    false    229                      0    214041 
   ppe_stocks 
   TABLE DATA               ?   COPY public.ppe_stocks (id, ppe_name, stock_received, stock_dispensed, stock_in_hand, hospital_id, created_at, updated_at, user_id) FROM stdin;
    public       rai    false    274   ?s      r           0    0    ppe_stocks_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.ppe_stocks_id_seq', 1, true);
            public       rai    false    273            ?
          0    213306 	   provinces 
   TABLE DATA               N   COPY public.provinces (id, province_name, created_at, updated_at) FROM stdin;
    public       rai    false    200   ?s      s           0    0    provinces_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.provinces_id_seq', 1, true);
            public       rai    false    199            ?
          0    213195    schema_migrations 
   TABLE DATA               4   COPY public.schema_migrations (version) FROM stdin;
    public       rai    false    181   )t      ?
          0    213479    simple_activities 
   TABLE DATA                 COPY public.simple_activities (id, tag_category_id, tag_category_name, larva_found, larva_type, io_action, removal_water_stagnant, removal_garbage, removal_rof_top_cleaned, old_record_sorted, sops_follow, comment, tag_name, tag_id, app_version, latitude, longitude, activity_time, os_version_number, os_version_name, user_id, hotspot_id, tehsil_id, tehsil_name, uc_name, uc_id, before_picture, after_picture, created_at, updated_at, department_id, department_name, district_id, district_name, description, is_bogus, province_id) FROM stdin;
    public       rai    false    228   hw      t           0    0    simple_activities_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.simple_activities_id_seq', 9, true);
            public       rai    false    227            ?
          0    213754 
   slideshows 
   TABLE DATA               {   COPY public.slideshows (id, name, activity_type, user_id, activity_ids, department_id, created_at, updated_at) FROM stdin;
    public       rai    false    248   ?y      u           0    0    slideshows_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.slideshows_id_seq', 1, false);
            public       rai    false    247            ?
          0    213699    surveillance_audits 
   TABLE DATA               -  COPY public.surveillance_audits (id, mobile_user_id, app_version, location, lat, lng, no_of_containers_checked, remarks, visited_before, simple_activity_id, rooftop_checked, material_provided, is_indoor, larvae_found_earlier, larvae_found, time_taken, picture_url, created_at, updated_at) FROM stdin;
    public       rai    false    246   ?y      v           0    0    surveillance_audits_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.surveillance_audits_id_seq', 1, false);
            public       rai    false    245            ?
          0    213426    tag_categories 
   TABLE DATA               z   COPY public.tag_categories (id, category_name, created_at, updated_at, urdu, m_category_id, category_name_en) FROM stdin;
    public       rai    false    218   ?y      w           0    0    tag_categories_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.tag_categories_id_seq', 5, true);
            public       rai    false    217            ?
          0    213415    tag_options 
   TABLE DATA               [   COPY public.tag_options (id, option_name, created_at, updated_at, m_option_id) FROM stdin;
    public       rai    false    216   ?z      x           0    0    tag_options_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.tag_options_id_seq', 1, false);
            public       rai    false    215            ?
          0    213364    tags 
   TABLE DATA               ?   COPY public.tags (id, tag_name, created_at, updated_at, tag_category_id, tag_image_url, tag_options, urdu, m_tag_id, m_category_id, tag_name_en) FROM stdin;
    public       rai    false    208   ?z      y           0    0    tags_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.tags_id_seq', 46, true);
            public       rai    false    207            ?
          0    213262    tehsils 
   TABLE DATA               W   COPY public.tehsils (id, tehsil_name, district_id, created_at, updated_at) FROM stdin;
    public       rai    false    192   x?      z           0    0    tehsils_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.tehsils_id_seq', 1, true);
            public       rai    false    191                      0    214081 	   test_logs 
   TABLE DATA               `  COPY public.test_logs (id, hct_first_reading, hct_first_reading_date, wbc_first_reading, wbc_first_reading_date, platelet_first_reading, platelet_first_reading_date, hct_second_reading, hct_second_reading_date, wbc_second_reading, wbc_second_reading_date, platelet_second_reading, platelet_second_reading_date, hct_third_reading, hct_third_reading_date, wbc_third_reading, wbc_third_reading_date, platelet_third_reading, platelet_third_reading_date, ns1, igg, igm, pcr, provisional_diagnosis, change_by, reporting_date, comments, patient_name, cnic, patient_id, created_at, updated_at, passport) FROM stdin;
    public       rai    false    280   Ȅ      {           0    0    test_logs_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.test_logs_id_seq', 2, true);
            public       rai    false    279            ?
          0    213619 
   tpv_audits 
   TABLE DATA               ?   COPY public.tpv_audits (id, department_id, department_name, tehsil_id, tehsil_name, audit_date, district_id, district_name, activity_ids, category_name, audit_type, created_at, updated_at, activity_type) FROM stdin;
    public       rai    false    236   ??      |           0    0    tpv_audits_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.tpv_audits_id_seq', 1, false);
            public       rai    false    235            ?
          0    213453    u_towns 
   TABLE DATA               w   COPY public.u_towns (id, name, townable_id, townable_type, tehsil_id, created_at, updated_at, tehsil_name) FROM stdin;
    public       rai    false    224   ??      }           0    0    u_towns_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.u_towns_id_seq', 1, false);
            public       rai    false    223            ?
          0    213273    ucs 
   TABLE DATA               g   COPY public.ucs (id, uc_name, district_id, tehsil_id, created_at, updated_at, province_id) FROM stdin;
    public       rai    false    194   ʅ      ~           0    0 
   ucs_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.ucs_id_seq', 1, true);
            public       rai    false    193            ?
          0    213437    user_categories 
   TABLE DATA               f   COPY public.user_categories (id, mobile_user_id, tag_category_id, created_at, updated_at) FROM stdin;
    public       rai    false    220   ?                 0    0    user_categories_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.user_categories_id_seq', 1, true);
            public       rai    false    219            ?
          0    213213    users 
   TABLE DATA                 COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at, username, sub_role, lab_id, role, district_id, hospital_id, department_id, tehsil_id, is_forgot, status, old_user_id, hotspot_status) FROM stdin;
    public       rai    false    184   U?      ?           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 7, true);
            public       rai    false    183                      0    213936    workplace_addresses 
   TABLE DATA               ?   COPY public.workplace_addresses (id, district_id, district_name, tehsil_id, tehsil_name, uc_id, uc_name, gp_dengue_patient_id, address, created_at, updated_at) FROM stdin;
    public       rai    false    260   ??      ?           0    0    workplace_addresses_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.workplace_addresses_id_seq', 1, false);
            public       rai    false    259            ?
          0    213594    zero_patients 
   TABLE DATA               ?   COPY public.zero_patients (id, user_id, hospital_id, hospital, district_id, district, t_type, created_at, updated_at, lab_id, lab, province_id) FROM stdin;
    public       rai    false    232   ?      ?           0    0    zero_patients_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.zero_patients_id_seq', 1, false);
            public       rai    false    231            ?	           2606    213210    ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         rai    false    182    182            ?	           2606    213337    audits_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.audits DROP CONSTRAINT audits_pkey;
       public         rai    false    204    204            
           2606    213881 	   beds_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.beds DROP CONSTRAINT beds_pkey;
       public         rai    false    252    252            /
           2606    213986    current_addresses_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.current_addresses
    ADD CONSTRAINT current_addresses_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.current_addresses DROP CONSTRAINT current_addresses_pkey;
       public         rai    false    268    268            ?	           2606    213450    department_tags_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.department_tags
    ADD CONSTRAINT department_tags_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.department_tags DROP CONSTRAINT department_tags_pkey;
       public         rai    false    222    222            ?	           2606    213303    departments_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.departments DROP CONSTRAINT departments_pkey;
       public         rai    false    198    198            ?	           2606    213259    districts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.districts DROP CONSTRAINT districts_pkey;
       public         rai    false    190    190            ?	           2606    213325    divisions_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.divisions DROP CONSTRAINT divisions_pkey;
       public         rai    false    202    202            
           2606    213914    gp_dengue_patients_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.gp_dengue_patients
    ADD CONSTRAINT gp_dengue_patients_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.gp_dengue_patients DROP CONSTRAINT gp_dengue_patients_pkey;
       public         rai    false    256    256            
           2606    213895    gp_dengue_users_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.gp_dengue_users
    ADD CONSTRAINT gp_dengue_users_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.gp_dengue_users DROP CONSTRAINT gp_dengue_users_pkey;
       public         rai    false    254    254            4
           2606    214001    gp_forms_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.gp_forms
    ADD CONSTRAINT gp_forms_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.gp_forms DROP CONSTRAINT gp_forms_pkey;
       public         rai    false    270    270            ,
           2606    213974    gp_lab_diagnostices_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.gp_lab_diagnostices
    ADD CONSTRAINT gp_lab_diagnostices_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.gp_lab_diagnostices DROP CONSTRAINT gp_lab_diagnostices_pkey;
       public         rai    false    266    266            &
           2606    213956    gp_lab_results_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.gp_lab_results
    ADD CONSTRAINT gp_lab_results_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.gp_lab_results DROP CONSTRAINT gp_lab_results_pkey;
       public         rai    false    262    262            ?	           2606    213674    gp_patients_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.gp_patients
    ADD CONSTRAINT gp_patients_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.gp_patients DROP CONSTRAINT gp_patients_pkey;
       public         rai    false    240    240            )
           2606    213965    gp_symptoms_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.gp_symptoms
    ADD CONSTRAINT gp_symptoms_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.gp_symptoms DROP CONSTRAINT gp_symptoms_pkey;
       public         rai    false    264    264            ?	           2606    213655    gp_users_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.gp_users
    ADD CONSTRAINT gp_users_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.gp_users DROP CONSTRAINT gp_users_pkey;
       public         rai    false    238    238            ?	           2606    213292    hospitals_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.hospitals DROP CONSTRAINT hospitals_pkey;
       public         rai    false    196    196            ?	           2606    213361    hotspots_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.hotspots
    ADD CONSTRAINT hotspots_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.hotspots DROP CONSTRAINT hotspots_pkey;
       public         rai    false    206    206            >
           2606    214068    insecticide_stocks_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.insecticide_stocks
    ADD CONSTRAINT insecticide_stocks_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.insecticide_stocks DROP CONSTRAINT insecticide_stocks_pkey;
       public         rai    false    278    278            ?	           2606    213401    lab_patients_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.lab_patients
    ADD CONSTRAINT lab_patients_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.lab_patients DROP CONSTRAINT lab_patients_pkey;
       public         rai    false    212    212            ?	           2606    213248    lab_results_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.lab_results
    ADD CONSTRAINT lab_results_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.lab_results DROP CONSTRAINT lab_results_pkey;
       public         rai    false    188    188            ?	           2606    213384 	   labs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.labs DROP CONSTRAINT labs_pkey;
       public         rai    false    210    210            ?	           2606    213696    larvae_auditeds_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.larvae_auditeds
    ADD CONSTRAINT larvae_auditeds_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.larvae_auditeds DROP CONSTRAINT larvae_auditeds_pkey;
       public         rai    false    244    244            
           2606    213816    legacy_activities_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.legacy_activities
    ADD CONSTRAINT legacy_activities_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.legacy_activities DROP CONSTRAINT legacy_activities_pkey;
       public         rai    false    250    250            8
           2606    214038    medicine_stocks_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.medicine_stocks
    ADD CONSTRAINT medicine_stocks_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.medicine_stocks DROP CONSTRAINT medicine_stocks_pkey;
       public         rai    false    272    272            ?	           2606    213614    mobile_user_tehsils_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.mobile_user_tehsils
    ADD CONSTRAINT mobile_user_tehsils_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.mobile_user_tehsils DROP CONSTRAINT mobile_user_tehsils_pkey;
       public         rai    false    234    234            ?	           2606    213412    mobile_users_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.mobile_users
    ADD CONSTRAINT mobile_users_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.mobile_users DROP CONSTRAINT mobile_users_pkey;
       public         rai    false    214    214            ?	           2606    213473    patient_activities_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.patient_activities
    ADD CONSTRAINT patient_activities_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.patient_activities DROP CONSTRAINT patient_activities_pkey;
       public         rai    false    226    226            ?	           2606    213685    patient_auditeds_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.patient_auditeds
    ADD CONSTRAINT patient_auditeds_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.patient_auditeds DROP CONSTRAINT patient_auditeds_pkey;
       public         rai    false    242    242            ?	           2606    213237    patients_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.patients DROP CONSTRAINT patients_pkey;
       public         rai    false    186    186            <
           2606    214057    pcr_machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.pcr_machines
    ADD CONSTRAINT pcr_machines_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.pcr_machines DROP CONSTRAINT pcr_machines_pkey;
       public         rai    false    276    276            
           2606    213929    permanent_addresses_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.permanent_addresses
    ADD CONSTRAINT permanent_addresses_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.permanent_addresses DROP CONSTRAINT permanent_addresses_pkey;
       public         rai    false    258    258            ?	           2606    213502    pictures_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.pictures DROP CONSTRAINT pictures_pkey;
       public         rai    false    230    230            :
           2606    214049    ppe_stocks_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.ppe_stocks
    ADD CONSTRAINT ppe_stocks_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.ppe_stocks DROP CONSTRAINT ppe_stocks_pkey;
       public         rai    false    274    274            ?	           2606    213314    provinces_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.provinces DROP CONSTRAINT provinces_pkey;
       public         rai    false    200    200            ?	           2606    213202    schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         rai    false    181    181            ?	           2606    213487    simple_activities_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.simple_activities
    ADD CONSTRAINT simple_activities_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.simple_activities DROP CONSTRAINT simple_activities_pkey;
       public         rai    false    228    228            
           2606    213763    slideshows_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.slideshows
    ADD CONSTRAINT slideshows_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.slideshows DROP CONSTRAINT slideshows_pkey;
       public         rai    false    248    248            ?	           2606    213707    surveillance_audits_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.surveillance_audits
    ADD CONSTRAINT surveillance_audits_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.surveillance_audits DROP CONSTRAINT surveillance_audits_pkey;
       public         rai    false    246    246            ?	           2606    213434    tag_categories_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tag_categories
    ADD CONSTRAINT tag_categories_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.tag_categories DROP CONSTRAINT tag_categories_pkey;
       public         rai    false    218    218            ?	           2606    213423    tag_options_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.tag_options
    ADD CONSTRAINT tag_options_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.tag_options DROP CONSTRAINT tag_options_pkey;
       public         rai    false    216    216            ?	           2606    213372 	   tags_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         rai    false    208    208            ?	           2606    213270    tehsils_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.tehsils
    ADD CONSTRAINT tehsils_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.tehsils DROP CONSTRAINT tehsils_pkey;
       public         rai    false    192    192            A
           2606    214089    test_logs_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.test_logs
    ADD CONSTRAINT test_logs_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.test_logs DROP CONSTRAINT test_logs_pkey;
       public         rai    false    280    280            ?	           2606    213627    tpv_audits_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.tpv_audits
    ADD CONSTRAINT tpv_audits_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.tpv_audits DROP CONSTRAINT tpv_audits_pkey;
       public         rai    false    236    236            ?	           2606    213461    u_towns_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.u_towns
    ADD CONSTRAINT u_towns_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.u_towns DROP CONSTRAINT u_towns_pkey;
       public         rai    false    224    224            ?	           2606    213281    ucs_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.ucs
    ADD CONSTRAINT ucs_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.ucs DROP CONSTRAINT ucs_pkey;
       public         rai    false    194    194            ?	           2606    213442    user_categories_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.user_categories
    ADD CONSTRAINT user_categories_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.user_categories DROP CONSTRAINT user_categories_pkey;
       public         rai    false    220    220            ?	           2606    213223 
   users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         rai    false    184    184            $
           2606    213944    workplace_addresses_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.workplace_addresses
    ADD CONSTRAINT workplace_addresses_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.workplace_addresses DROP CONSTRAINT workplace_addresses_pkey;
       public         rai    false    260    260            ?	           2606    213603    zero_patients_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.zero_patients
    ADD CONSTRAINT zero_patients_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.zero_patients DROP CONSTRAINT zero_patients_pkey;
       public         rai    false    232    232            ?	           1259    213339    associated_index    INDEX     ]   CREATE INDEX associated_index ON public.audits USING btree (associated_type, associated_id);
 $   DROP INDEX public.associated_index;
       public         rai    false    204    204            ?	           1259    213338    auditable_index    INDEX     c   CREATE INDEX auditable_index ON public.audits USING btree (auditable_type, auditable_id, version);
 #   DROP INDEX public.auditable_index;
       public         rai    false    204    204    204            ?	           1259    213342    index_audits_on_created_at    INDEX     S   CREATE INDEX index_audits_on_created_at ON public.audits USING btree (created_at);
 .   DROP INDEX public.index_audits_on_created_at;
       public         rai    false    204            ?	           1259    213341    index_audits_on_request_uuid    INDEX     W   CREATE INDEX index_audits_on_request_uuid ON public.audits USING btree (request_uuid);
 0   DROP INDEX public.index_audits_on_request_uuid;
       public         rai    false    204            	
           1259    213882    index_beds_on_hospital_id    INDEX     Q   CREATE INDEX index_beds_on_hospital_id ON public.beds USING btree (hospital_id);
 -   DROP INDEX public.index_beds_on_hospital_id;
       public         rai    false    252            0
           1259    213987 &   index_current_addresses_on_district_id    INDEX     k   CREATE INDEX index_current_addresses_on_district_id ON public.current_addresses USING btree (district_id);
 :   DROP INDEX public.index_current_addresses_on_district_id;
       public         rai    false    268            1
           1259    213988 $   index_current_addresses_on_tehsil_id    INDEX     g   CREATE INDEX index_current_addresses_on_tehsil_id ON public.current_addresses USING btree (tehsil_id);
 8   DROP INDEX public.index_current_addresses_on_tehsil_id;
       public         rai    false    268            2
           1259    213989     index_current_addresses_on_uc_id    INDEX     _   CREATE INDEX index_current_addresses_on_uc_id ON public.current_addresses USING btree (uc_id);
 4   DROP INDEX public.index_current_addresses_on_uc_id;
       public         rai    false    268            
           1259    213916 &   index_gp_dengue_patients_on_contact_no    INDEX     k   CREATE INDEX index_gp_dengue_patients_on_contact_no ON public.gp_dengue_patients USING btree (contact_no);
 :   DROP INDEX public.index_gp_dengue_patients_on_contact_no;
       public         rai    false    256            
           1259    213917 1   index_gp_dengue_patients_on_provisional_diagnosis    INDEX     ?   CREATE INDEX index_gp_dengue_patients_on_provisional_diagnosis ON public.gp_dengue_patients USING btree (provisional_diagnosis);
 E   DROP INDEX public.index_gp_dengue_patients_on_provisional_diagnosis;
       public         rai    false    256            
           1259    213918 '   index_gp_dengue_patients_on_reffer_type    INDEX     m   CREATE INDEX index_gp_dengue_patients_on_reffer_type ON public.gp_dengue_patients USING btree (reffer_type);
 ;   DROP INDEX public.index_gp_dengue_patients_on_reffer_type;
       public         rai    false    256            
           1259    213898 #   index_gp_dengue_users_on_contact_no    INDEX     l   CREATE UNIQUE INDEX index_gp_dengue_users_on_contact_no ON public.gp_dengue_users USING btree (contact_no);
 7   DROP INDEX public.index_gp_dengue_users_on_contact_no;
       public         rai    false    254            
           1259    213900 $   index_gp_dengue_users_on_district_id    INDEX     g   CREATE INDEX index_gp_dengue_users_on_district_id ON public.gp_dengue_users USING btree (district_id);
 8   DROP INDEX public.index_gp_dengue_users_on_district_id;
       public         rai    false    254            
           1259    213896    index_gp_dengue_users_on_email    INDEX     b   CREATE UNIQUE INDEX index_gp_dengue_users_on_email ON public.gp_dengue_users USING btree (email);
 2   DROP INDEX public.index_gp_dengue_users_on_email;
       public         rai    false    254            
           1259    213903 $   index_gp_dengue_users_on_hospital_id    INDEX     g   CREATE INDEX index_gp_dengue_users_on_hospital_id ON public.gp_dengue_users USING btree (hospital_id);
 8   DROP INDEX public.index_gp_dengue_users_on_hospital_id;
       public         rai    false    254            
           1259    213897 $   index_gp_dengue_users_on_pmdc_number    INDEX     n   CREATE UNIQUE INDEX index_gp_dengue_users_on_pmdc_number ON public.gp_dengue_users USING btree (pmdc_number);
 8   DROP INDEX public.index_gp_dengue_users_on_pmdc_number;
       public         rai    false    254            
           1259    213899    index_gp_dengue_users_on_role    INDEX     Y   CREATE INDEX index_gp_dengue_users_on_role ON public.gp_dengue_users USING btree (role);
 1   DROP INDEX public.index_gp_dengue_users_on_role;
       public         rai    false    254            
           1259    213901 "   index_gp_dengue_users_on_tehsil_id    INDEX     c   CREATE INDEX index_gp_dengue_users_on_tehsil_id ON public.gp_dengue_users USING btree (tehsil_id);
 6   DROP INDEX public.index_gp_dengue_users_on_tehsil_id;
       public         rai    false    254            
           1259    213902    index_gp_dengue_users_on_uc_id    INDEX     [   CREATE INDEX index_gp_dengue_users_on_uc_id ON public.gp_dengue_users USING btree (uc_id);
 2   DROP INDEX public.index_gp_dengue_users_on_uc_id;
       public         rai    false    254            5
           1259    214002 #   index_gp_forms_on_gp_dengue_user_id    INDEX     e   CREATE INDEX index_gp_forms_on_gp_dengue_user_id ON public.gp_forms USING btree (gp_dengue_user_id);
 7   DROP INDEX public.index_gp_forms_on_gp_dengue_user_id;
       public         rai    false    270            6
           1259    214003 '   index_gp_forms_on_provisional_diagnosis    INDEX     m   CREATE INDEX index_gp_forms_on_provisional_diagnosis ON public.gp_forms USING btree (provisional_diagnosis);
 ;   DROP INDEX public.index_gp_forms_on_provisional_diagnosis;
       public         rai    false    270            -
           1259    213975 1   index_gp_lab_diagnostices_on_gp_dengue_patient_id    INDEX     ?   CREATE INDEX index_gp_lab_diagnostices_on_gp_dengue_patient_id ON public.gp_lab_diagnostices USING btree (gp_dengue_patient_id);
 E   DROP INDEX public.index_gp_lab_diagnostices_on_gp_dengue_patient_id;
       public         rai    false    266            '
           1259    213957 ,   index_gp_lab_results_on_gp_dengue_patient_id    INDEX     w   CREATE INDEX index_gp_lab_results_on_gp_dengue_patient_id ON public.gp_lab_results USING btree (gp_dengue_patient_id);
 @   DROP INDEX public.index_gp_lab_results_on_gp_dengue_patient_id;
       public         rai    false    262            *
           1259    213966 )   index_gp_symptoms_on_gp_dengue_patient_id    INDEX     q   CREATE INDEX index_gp_symptoms_on_gp_dengue_patient_id ON public.gp_symptoms USING btree (gp_dengue_patient_id);
 =   DROP INDEX public.index_gp_symptoms_on_gp_dengue_patient_id;
       public         rai    false    264            ?	           1259    213657    index_gp_users_on_district    INDEX     S   CREATE INDEX index_gp_users_on_district ON public.gp_users USING btree (district);
 .   DROP INDEX public.index_gp_users_on_district;
       public         rai    false    238            ?	           1259    213658    index_gp_users_on_doctor_name    INDEX     Y   CREATE INDEX index_gp_users_on_doctor_name ON public.gp_users USING btree (doctor_name);
 1   DROP INDEX public.index_gp_users_on_doctor_name;
       public         rai    false    238            ?	           1259    213659    index_gp_users_on_email    INDEX     M   CREATE INDEX index_gp_users_on_email ON public.gp_users USING btree (email);
 +   DROP INDEX public.index_gp_users_on_email;
       public         rai    false    238            ?	           1259    213660    index_gp_users_on_facility_type    INDEX     ]   CREATE INDEX index_gp_users_on_facility_type ON public.gp_users USING btree (facility_type);
 3   DROP INDEX public.index_gp_users_on_facility_type;
       public         rai    false    238            ?	           1259    213661 "   index_gp_users_on_is_mobile_signup    INDEX     c   CREATE INDEX index_gp_users_on_is_mobile_signup ON public.gp_users USING btree (is_mobile_signup);
 6   DROP INDEX public.index_gp_users_on_is_mobile_signup;
       public         rai    false    238            ?	           1259    213656    index_gp_users_on_name    INDEX     K   CREATE INDEX index_gp_users_on_name ON public.gp_users USING btree (name);
 *   DROP INDEX public.index_gp_users_on_name;
       public         rai    false    238            ?	           1259    213662    index_gp_users_on_password    INDEX     S   CREATE INDEX index_gp_users_on_password ON public.gp_users USING btree (password);
 .   DROP INDEX public.index_gp_users_on_password;
       public         rai    false    238            ?	           1259    213663    index_gp_users_on_pmdc_number    INDEX     Y   CREATE INDEX index_gp_users_on_pmdc_number ON public.gp_users USING btree (pmdc_number);
 1   DROP INDEX public.index_gp_users_on_pmdc_number;
       public         rai    false    238            ?	           1259    214078    index_hospitals_on_h_type    INDEX     Q   CREATE INDEX index_hospitals_on_h_type ON public.hospitals USING btree (h_type);
 -   DROP INDEX public.index_hospitals_on_h_type;
       public         rai    false    196            ?	           1259    214027 '   index_lab_patients_on_confirmation_date    INDEX     m   CREATE INDEX index_lab_patients_on_confirmation_date ON public.lab_patients USING btree (confirmation_date);
 ;   DROP INDEX public.index_lab_patients_on_confirmation_date;
       public         rai    false    212            ?	           1259    213728    index_lab_patients_on_is_dpc    INDEX     W   CREATE INDEX index_lab_patients_on_is_dpc ON public.lab_patients USING btree (is_dpc);
 0   DROP INDEX public.index_lab_patients_on_is_dpc;
       public         rai    false    212            ?	           1259    213591    index_lab_patients_on_lab_id    INDEX     W   CREATE INDEX index_lab_patients_on_lab_id ON public.lab_patients USING btree (lab_id);
 0   DROP INDEX public.index_lab_patients_on_lab_id;
       public         rai    false    212            ?	           1259    213750 #   index_lab_patients_on_transfer_type    INDEX     e   CREATE INDEX index_lab_patients_on_transfer_type ON public.lab_patients USING btree (transfer_type);
 7   DROP INDEX public.index_lab_patients_on_transfer_type;
       public         rai    false    212            
           1259    213818 #   index_legacy_activities_on_act_date    INDEX     e   CREATE INDEX index_legacy_activities_on_act_date ON public.legacy_activities USING btree (act_date);
 7   DROP INDEX public.index_legacy_activities_on_act_date;
       public         rai    false    250            
           1259    213817 &   index_legacy_activities_on_district_id    INDEX     k   CREATE INDEX index_legacy_activities_on_district_id ON public.legacy_activities USING btree (district_id);
 :   DROP INDEX public.index_legacy_activities_on_district_id;
       public         rai    false    250            ?	           1259    213616 +   index_mobile_user_tehsils_on_mobile_user_id    INDEX     u   CREATE INDEX index_mobile_user_tehsils_on_mobile_user_id ON public.mobile_user_tehsils USING btree (mobile_user_id);
 ?   DROP INDEX public.index_mobile_user_tehsils_on_mobile_user_id;
       public         rai    false    234            ?	           1259    213615 &   index_mobile_user_tehsils_on_tehsil_id    INDEX     k   CREATE INDEX index_mobile_user_tehsils_on_tehsil_id ON public.mobile_user_tehsils USING btree (tehsil_id);
 :   DROP INDEX public.index_mobile_user_tehsils_on_tehsil_id;
       public         rai    false    234            ?	           1259    213476 &   index_patient_activities_on_patient_id    INDEX     k   CREATE INDEX index_patient_activities_on_patient_id ON public.patient_activities USING btree (patient_id);
 :   DROP INDEX public.index_patient_activities_on_patient_id;
       public         rai    false    226            ?	           1259    213523 )   index_patient_activities_on_patient_place    INDEX     q   CREATE INDEX index_patient_activities_on_patient_place ON public.patient_activities USING btree (patient_place);
 =   DROP INDEX public.index_patient_activities_on_patient_place;
       public         rai    false    226            ?	           1259    213632 1   index_patient_activities_on_provisional_diagnosis    INDEX     ?   CREATE INDEX index_patient_activities_on_provisional_diagnosis ON public.patient_activities USING btree (provisional_diagnosis);
 E   DROP INDEX public.index_patient_activities_on_provisional_diagnosis;
       public         rai    false    226            ?	           1259    213474 +   index_patient_activities_on_tag_category_id    INDEX     u   CREATE INDEX index_patient_activities_on_tag_category_id ON public.patient_activities USING btree (tag_category_id);
 ?   DROP INDEX public.index_patient_activities_on_tag_category_id;
       public         rai    false    226            ?	           1259    213475 #   index_patient_activities_on_user_id    INDEX     e   CREATE INDEX index_patient_activities_on_user_id ON public.patient_activities USING btree (user_id);
 7   DROP INDEX public.index_patient_activities_on_user_id;
       public         rai    false    226            ?	           1259    213373    index_patients_on_cnic    INDEX     K   CREATE INDEX index_patients_on_cnic ON public.patients USING btree (cnic);
 *   DROP INDEX public.index_patients_on_cnic;
       public         rai    false    186            ?	           1259    214016 #   index_patients_on_confirmation_date    INDEX     e   CREATE INDEX index_patients_on_confirmation_date ON public.patients USING btree (confirmation_date);
 7   DROP INDEX public.index_patients_on_confirmation_date;
       public         rai    false    186            ?	           1259    214106 !   index_patients_on_confirmation_id    INDEX     a   CREATE INDEX index_patients_on_confirmation_id ON public.patients USING btree (confirmation_id);
 5   DROP INDEX public.index_patients_on_confirmation_id;
       public         rai    false    186            ?	           1259    213808    index_patients_on_deleted_at    INDEX     W   CREATE INDEX index_patients_on_deleted_at ON public.patients USING btree (deleted_at);
 0   DROP INDEX public.index_patients_on_deleted_at;
       public         rai    false    186            ?	           1259    213718    index_patients_on_is_dpc    INDEX     O   CREATE INDEX index_patients_on_is_dpc ON public.patients USING btree (is_dpc);
 ,   DROP INDEX public.index_patients_on_is_dpc;
       public         rai    false    186            ?	           1259    213751     index_patients_on_lab_patient_id    INDEX     _   CREATE INDEX index_patients_on_lab_patient_id ON public.patients USING btree (lab_patient_id);
 4   DROP INDEX public.index_patients_on_lab_patient_id;
       public         rai    false    186            ?	           1259    214069    index_patients_on_lab_user_id    INDEX     Y   CREATE INDEX index_patients_on_lab_user_id ON public.patients USING btree (lab_user_id);
 1   DROP INDEX public.index_patients_on_lab_user_id;
       public         rai    false    186            ?	           1259    214131    index_patients_on_passport    INDEX     S   CREATE INDEX index_patients_on_passport ON public.patients USING btree (passport);
 .   DROP INDEX public.index_patients_on_passport;
       public         rai    false    186            ?	           1259    213739    index_patients_on_transfer_type    INDEX     ]   CREATE INDEX index_patients_on_transfer_type ON public.patients USING btree (transfer_type);
 3   DROP INDEX public.index_patients_on_transfer_type;
       public         rai    false    186            
           1259    213930 (   index_permanent_addresses_on_district_id    INDEX     o   CREATE INDEX index_permanent_addresses_on_district_id ON public.permanent_addresses USING btree (district_id);
 <   DROP INDEX public.index_permanent_addresses_on_district_id;
       public         rai    false    258            
           1259    213933 1   index_permanent_addresses_on_gp_dengue_patient_id    INDEX     ?   CREATE INDEX index_permanent_addresses_on_gp_dengue_patient_id ON public.permanent_addresses USING btree (gp_dengue_patient_id);
 E   DROP INDEX public.index_permanent_addresses_on_gp_dengue_patient_id;
       public         rai    false    258            
           1259    213931 &   index_permanent_addresses_on_tehsil_id    INDEX     k   CREATE INDEX index_permanent_addresses_on_tehsil_id ON public.permanent_addresses USING btree (tehsil_id);
 :   DROP INDEX public.index_permanent_addresses_on_tehsil_id;
       public         rai    false    258            
           1259    213932 "   index_permanent_addresses_on_uc_id    INDEX     c   CREATE INDEX index_permanent_addresses_on_uc_id ON public.permanent_addresses USING btree (uc_id);
 6   DROP INDEX public.index_permanent_addresses_on_uc_id;
       public         rai    false    258            ?	           1259    213503     index_pictures_on_pictureable_id    INDEX     _   CREATE INDEX index_pictures_on_pictureable_id ON public.pictures USING btree (pictureable_id);
 4   DROP INDEX public.index_pictures_on_pictureable_id;
       public         rai    false    230            ?	           1259    213491 %   index_simple_activities_on_hotspot_id    INDEX     i   CREATE INDEX index_simple_activities_on_hotspot_id ON public.simple_activities USING btree (hotspot_id);
 9   DROP INDEX public.index_simple_activities_on_hotspot_id;
       public         rai    false    228            ?	           1259    213488 *   index_simple_activities_on_tag_category_id    INDEX     s   CREATE INDEX index_simple_activities_on_tag_category_id ON public.simple_activities USING btree (tag_category_id);
 >   DROP INDEX public.index_simple_activities_on_tag_category_id;
       public         rai    false    228            ?	           1259    213489 !   index_simple_activities_on_tag_id    INDEX     a   CREATE INDEX index_simple_activities_on_tag_id ON public.simple_activities USING btree (tag_id);
 5   DROP INDEX public.index_simple_activities_on_tag_id;
       public         rai    false    228            ?	           1259    213490 "   index_simple_activities_on_user_id    INDEX     c   CREATE INDEX index_simple_activities_on_user_id ON public.simple_activities USING btree (user_id);
 6   DROP INDEX public.index_simple_activities_on_user_id;
       public         rai    false    228            ?	           1259    213764 !   index_slideshows_on_activity_type    INDEX     a   CREATE INDEX index_slideshows_on_activity_type ON public.slideshows USING btree (activity_type);
 5   DROP INDEX public.index_slideshows_on_activity_type;
       public         rai    false    248             
           1259    213765    index_slideshows_on_user_id    INDEX     U   CREATE INDEX index_slideshows_on_user_id ON public.slideshows USING btree (user_id);
 /   DROP INDEX public.index_slideshows_on_user_id;
       public         rai    false    248            ?
           1259    214090    index_test_logs_on_patient_id    INDEX     Y   CREATE INDEX index_test_logs_on_patient_id ON public.test_logs USING btree (patient_id);
 1   DROP INDEX public.index_test_logs_on_patient_id;
       public         rai    false    280            ?	           1259    213631 !   index_tpv_audits_on_category_name    INDEX     a   CREATE INDEX index_tpv_audits_on_category_name ON public.tpv_audits USING btree (category_name);
 5   DROP INDEX public.index_tpv_audits_on_category_name;
       public         rai    false    236            ?	           1259    213628 !   index_tpv_audits_on_department_id    INDEX     a   CREATE INDEX index_tpv_audits_on_department_id ON public.tpv_audits USING btree (department_id);
 5   DROP INDEX public.index_tpv_audits_on_department_id;
       public         rai    false    236            ?	           1259    213630    index_tpv_audits_on_district_id    INDEX     ]   CREATE INDEX index_tpv_audits_on_district_id ON public.tpv_audits USING btree (district_id);
 3   DROP INDEX public.index_tpv_audits_on_district_id;
       public         rai    false    236            ?	           1259    213629    index_tpv_audits_on_tehsil_id    INDEX     Y   CREATE INDEX index_tpv_audits_on_tehsil_id ON public.tpv_audits USING btree (tehsil_id);
 1   DROP INDEX public.index_tpv_audits_on_tehsil_id;
       public         rai    false    236            ?	           1259    213462    index_u_towns_on_townable_id    INDEX     W   CREATE INDEX index_u_towns_on_townable_id ON public.u_towns USING btree (townable_id);
 0   DROP INDEX public.index_u_towns_on_townable_id;
       public         rai    false    224            ?	           1259    213708    index_users_on_department_id    INDEX     W   CREATE INDEX index_users_on_department_id ON public.users USING btree (department_id);
 0   DROP INDEX public.index_users_on_department_id;
       public         rai    false    184            ?	           1259    213586    index_users_on_district_id    INDEX     S   CREATE INDEX index_users_on_district_id ON public.users USING btree (district_id);
 .   DROP INDEX public.index_users_on_district_id;
       public         rai    false    184            ?	           1259    213588 *   index_users_on_district_id_and_hospital_id    INDEX     p   CREATE INDEX index_users_on_district_id_and_hospital_id ON public.users USING btree (district_id, hospital_id);
 >   DROP INDEX public.index_users_on_district_id_and_hospital_id;
       public         rai    false    184    184            ?	           1259    213590 %   index_users_on_district_id_and_lab_id    INDEX     f   CREATE INDEX index_users_on_district_id_and_lab_id ON public.users USING btree (district_id, lab_id);
 9   DROP INDEX public.index_users_on_district_id_and_lab_id;
       public         rai    false    184    184            ?	           1259    213587    index_users_on_hospital_id    INDEX     S   CREATE INDEX index_users_on_hospital_id ON public.users USING btree (hospital_id);
 .   DROP INDEX public.index_users_on_hospital_id;
       public         rai    false    184            ?	           1259    213589    index_users_on_lab_id    INDEX     I   CREATE INDEX index_users_on_lab_id ON public.users USING btree (lab_id);
 )   DROP INDEX public.index_users_on_lab_id;
       public         rai    false    184            ?	           1259    213225 #   index_users_on_reset_password_token    INDEX     l   CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         rai    false    184            ?	           1259    213585    index_users_on_role    INDEX     E   CREATE INDEX index_users_on_role ON public.users USING btree (role);
 '   DROP INDEX public.index_users_on_role;
       public         rai    false    184            ?	           1259    213226    index_users_on_username    INDEX     M   CREATE INDEX index_users_on_username ON public.users USING btree (username);
 +   DROP INDEX public.index_users_on_username;
       public         rai    false    184            
           1259    213945 (   index_workplace_addresses_on_district_id    INDEX     o   CREATE INDEX index_workplace_addresses_on_district_id ON public.workplace_addresses USING btree (district_id);
 <   DROP INDEX public.index_workplace_addresses_on_district_id;
       public         rai    false    260             
           1259    213948 1   index_workplace_addresses_on_gp_dengue_patient_id    INDEX     ?   CREATE INDEX index_workplace_addresses_on_gp_dengue_patient_id ON public.workplace_addresses USING btree (gp_dengue_patient_id);
 E   DROP INDEX public.index_workplace_addresses_on_gp_dengue_patient_id;
       public         rai    false    260            !
           1259    213946 &   index_workplace_addresses_on_tehsil_id    INDEX     k   CREATE INDEX index_workplace_addresses_on_tehsil_id ON public.workplace_addresses USING btree (tehsil_id);
 :   DROP INDEX public.index_workplace_addresses_on_tehsil_id;
       public         rai    false    260            "
           1259    213947 "   index_workplace_addresses_on_uc_id    INDEX     c   CREATE INDEX index_workplace_addresses_on_uc_id ON public.workplace_addresses USING btree (uc_id);
 6   DROP INDEX public.index_workplace_addresses_on_uc_id;
       public         rai    false    260            ?	           1259    213606 "   index_zero_patients_on_district_id    INDEX     c   CREATE INDEX index_zero_patients_on_district_id ON public.zero_patients USING btree (district_id);
 6   DROP INDEX public.index_zero_patients_on_district_id;
       public         rai    false    232            ?	           1259    213605 "   index_zero_patients_on_hospital_id    INDEX     c   CREATE INDEX index_zero_patients_on_hospital_id ON public.zero_patients USING btree (hospital_id);
 6   DROP INDEX public.index_zero_patients_on_hospital_id;
       public         rai    false    232            ?	           1259    213604    index_zero_patients_on_user_id    INDEX     [   CREATE INDEX index_zero_patients_on_user_id ON public.zero_patients USING btree (user_id);
 2   DROP INDEX public.index_zero_patients_on_user_id;
       public         rai    false    232            ?	           1259    213340 
   user_index    INDEX     K   CREATE INDEX user_index ON public.audits USING btree (user_id, user_type);
    DROP INDEX public.user_index;
       public         rai    false    204    204            ?
   ?   x?K?+?,???M?+?LI-K??/ ???u?t??-?M?LL?L?-̍?Hq??qqq ?p^      ?
   |  x??W[o?6~v~? ?m?!J?d?i?\?E?4??>Z?,b???TRg?ߡ.?l+m??n?a?????_>?	?\a?h?&?/?ۙ?&?пbA?????*6??*c?5??ƫ&?K??[
to????<H?,??o͕?[*?L???cG??#??[Z?????3????H?%%8??=Û?????M%?s2?c????7???M"DP)??{?rQMҨ???ռ?R???
???K}??U?v??9?Ԓ.ya-i????b|?T?H???J?X?L?,?µ??Sj?i???E{֚??Vb)K.TO?6u????{??B?=??DD Yǁ?cM ???U?Dx?ܢh??lmC?/?>4?ǽ??۞y KJ?Vn?>ʝӂ߲"??]A*?	?cSG|4?:(%9.4??z??e?AQ?PG2V??FRaUɾDu1k?A:/4oS(u?!O"^H?F<;Jh$)q?]I?p*?	i??LJPv?&???!]??r˖?w?(?̂?ZcŶn:?=?X?m?P$???pp?n?(?RE?e٩z??p??k??40?R?`??8?]̫B?Aft?8`6?:;{w$#T?PH??qj'??`??sfoF"x~֦n???4/??T???a???}?do?I????H???f????OB0:K{;?u/I?cVO
??K????+V??]?nL??(?5?͑l?Ur??q?? o.u
?????F??KAo?`S?;a?s??h??a ?Z?<??C??i06{?)??)??@v=W??y???1?????D ??@7?o?GCk?Phy6???s+ I?lp??ğ짆o8h??o>};??3D]????@???Y??LMg???۱?jJ?M??<Дn?/yC?T??+&???mq? ?7͡gj???l?4?yc?G?t.?G???R???8??ۛs??H??Js=?0VT????5???`?????w\?t[??c?v???}X???t?Q???? ?wC???G?1??:1??X?S㗚<D$????]?dT??)?+Ƞ????9??k|??s?+??X"V?Q?k<?m??;??w|i??K?1???5??@΋???1?w???[?????Kw]%?>???Nz^.????ӛ/????S???????q`#;?КY^?-졹E?(?3?=]Ǝe#??4[????y0?r?sbd??9C????.??t]?b??=#;O???r??8ȯ?׫???C@?_(=&^/?K`l???Ǜ#?;$?????|?1?u?|??!_????????]3???????y*⭛????}"܅??a???q?{?y????{??A?nP?@??`d??0?O?´ =??..VO????????|??Ǐ?^??C?>?8?`.?P_???V臮5s??؎?8???k?hko>Ea??????????\=3      ?
   [   x?]???0??Y??ڌ?!:A???E??{݁
???~? p?W/???4ħRc???}&???~5?Ch^M?=??b6\6??we???            x?????? ? ?      ?
   J   x?}???0?3Taa?$???C=?p~???p??y??V?\???؟پ\rFT6?????k?j?/a?`?!?      ?
   D   x?3?N????QpM)MN,????t???LM?4202?50?50Q04?26?22Գ4406??#????? ???      ?
   ?   x?}???PD?ݯ????????Xicae?
	70???i&d?3g2m??!??%???L%?)?sl?OYP`7???>?%???^?lB?d?-? pҷ???U-??F?????)[????Վڡ??Ƨ?z?j?pi?qB??e??/|??~F?b???D,      ?
   ?   x?}??N?0@??W?Ŏ?:="??\?u"??n*TH|=??*?o??~F???49???P??\??,	?&??g???<L?p1?vY?
??h})!o???S??2dc縄??i??X???[+?9Bc??V???C???b???{?XB??t??Qߴ_?M>??p???Z?_??N?'?5?s?J ?U?? ?EӐW?5d?sq	!ļa~??i#?u??lD\«?=???      ?
      x?????? ? ?      ?
   
  x?u??n?0D?7_q,??k;X?4?@?A??T??$??8r????R?.?Y????袱?}?}?-??????#?l+_'Ѯ6???ܜ^?f8?K??\Ti???????I?UǢܝ!s{?}C?o??r??FW?P????KAQ$'Q,`5&!UJ?IW?????ŭ;?@1,]??)??????}u??5???¼v??j?Mq????????????Nw??X(??>3&1??.ĘӘ+?p?Ք8??'??M?΂ ??d^W            x?????? ? ?      	      x?????? ? ?            x?????? ? ?      ?
      x?????? ? ?            x?????? ? ?      ?
      x?????? ? ?      ?
   p   x?3??JMU??/.?,I?Q?I??/J?4?(?,K,I??FF???F?Ff
FV??V??z&?????b?88?????$&? ??????H????????@C??1z\\\ 	y)?      ?
   ?   x?ŏ?JA?ϳO?/??t?l???? Qd???I:fqw&δ|z#?E?x?PTA??4??p???	?x	?d?g?dX??`?????Y9?????y<e?9?FH?5?{=	(??`?Y ?VΜt??/Y?????Qa?D??|?s?Z4d?J?%???{?]W9[7HKE%9????ǶjꮭkC?e?,???????w+???|e;G?~bm??(? ^?{?            x?????? ? ?      ?
      x?????? ? ?      ?
   j   x?3???Â ??????P??H??L????????R???????V#q#.#?2~???%?e?F@~q&?D??5F?@+?[ZZX???Z??"ա1z\\\ w?D?      ?
      x?????? ? ?      ?
      x?????? ? ?      ?
      x?????? ? ?         @   x?3?tI?()???51?45?44????4?4202?54?52S02?"=##cK3?R\1z\\\ :?      ?
   -   x?3?4B###]C]C3+cK+c#=s3Sc|R\1z\\\ |g?      ?
   ?   x?=?O?0????)<xu?}7?&?????x\? ?H??]$x.? o?1????[?&??;w?i?ӫ?d?V?0[p??M???x??C??ʴ/? qg???twgrĀC??J?Hd*?֠???\?P1!??kR?K?????B ?XZ3J??+?      ?
      x?????? ? ?      ?
      x?????? ? ?      ?
   M  x??R?n?0>?O?(J??e?!?v?X7QN#¨TZE???s?R???X???N??E???k?Fun??L1?k?Kic?{?y
/TPv?Ju;??@j);es?v?????7??????bV}??.S?&1ZВ?{ހM?8[?a?$mڴˉ/yV?n?x??ۼfo}??a?u?D?
]??P??7???[,?c??/Y6??H?iU??)?FP???z?????3՟橃?Eq?h'?? C͹i?j??0?5*?h??Q'?x?$??1?Y???B4?E/s?ѕ?c-T??P??0?һ?t,WA??;???	3g]4?F?9ľ Ťy6???? 2%??         2   x?3???4????4?4202?54?52S02?"cS=#33?R\1z\\\ ?I?            x?????? ? ?      ?
     x????j!@??W?"?8???B?m???l??v?.e?m????????????'?X/O?s|????g??B?B??G?ZKg8SB?e?b????????H??mǘ?rH?8??^?????G?U??I??9s겄?+?љ?????KhFb?"?ر?|???.?Y	[?J??%?%???͵???k?=?D"*?<ъ?>?a?I?	!?l?4Ny????ǰ??]???Cl????q??B?3K&cЖPNq???????tZ??)??)u9?k?F?Uu}?r?r?ZVU?c 2         A   x?3???/.,?,?W?K-)?44?4????4?4202?54?52S02?!#=?
|R\1z\\\ {?      ?
   3   x?3?(??JL?4202?54?52S02?2??25?304152?#????? ?Z{      ?
   /  x?U?ɑ$!E?eL?V_?;?+A *?/?]	Q??,??O&^љ}??:?U/??I????? ???>+ƲWć??zA&??l?'?"{?+?\?U??T??Pǽ#Qi:~????Jr|b????'5??m?0X??d!??E?e\?6ui?\??ʳ?*?as{??	????{2\܎??_?	J"????I?"s??"Gh*N;?~?r??e?3m?]e>?6??"e/r9???h;پP???>??{??I? Ź?W???DD?1E?V%v???Ő?Փ?! ?WC?&?<?Q??Z$ڊ?AyѪ?:??B/>??]m?^?>?^???6?\?m??g?V?I??J??Dֲ	N??Q??G?/??X????ũ?yr47?????%NtdmϓU?^Q9?????H$?????{????Y?a?ZAF?*N?????{5
????^??????F?'??ݟ?^?F?9?"?Q??#ZAF??EW[?s*?ѥ?g2lt.h#kbh?=??D?"y?B???1?Dh?*??W<???^?pc? ?e^??/N??D?!??mY?+jZ???.v=?ݿ&?v?i
???nI???_DF4?b<!?4-??_{bL?qW?s??yJ?I???	?0??*??n޶	?<*I??Bl?w.??_D?у?Z$???6?54??C|?Eo???HI????wS݃???7?99)_?6?Ux`8???<?ZA??Q????9٠??C$jx?K?IVв4x%??????]????(?s??g-N??j?l<??Xa??m>Gi????g}?MMD9g>'F????~????      ?
   5  x??V?n?@|?|? ?=g?x/o?@?@%.⡒??????????????&?R?"h????c??̬FF?سЄ???????/??+??_??)`???
?RFl?\i%Y?a.h:tq?3)?ISvmU& >???NW?:????Ů??mڅ?~???񸩊~ׅ4?b
??t.?.??@Z??M????,?J?/????B?????%?4?A?? (n?P;A?$0???(u4?u?j?:yZ?
?Wm??U??Z?L>j?ez?M???????mU?	??1v?dI?i??Gm??s????gN(.$IG??d6?qz??????d????=?[<??ZK)`"Tvb??????t#9)yF????P????R)??M`???&?{W?????k߰?K??׷[&͠8??V\??q??& ??@%??N?گ}?????ɛ??????$??GOA?1hR???E+1At?f??_?7??B??A?D?(?.?xX(&}?6}~曪????b???x8???U???/???CY??H?ܹ???[ǌ???q47?);??RzbV???????챬?:?8?D??,	??#t?g??W?2G?      ?
      x?????? ? ?      ?
      x?????? ? ?      ?
   ?   x?}??J?@?ϳO???3??M?z??x?a????F?B-?B(J)??9f??1?!?????;??O?r??!?????-??k?2t?q?&?,'?.?Lͫ??3?c<w`T?E5e5??ti???t?7949ARn??K?~k?S?????Z?]j?))W???q(R?j&??ǐ???m??)n7x^????????VO???Cݰ?!???m6?ח=??;?????      ?
      x?????? ? ?      ?
   j	  x?}X?nY?>y?~?М?>?;?V܌d5q???q{?6Q.3"Q.??y??&?????9l?e????$?t@??c?Wu???????j?$???????(??"??P?\}e"?;?t??S)?L?????Q?	???]??n???[?b~?v??)?????d??~??/7??S	7???W????{kj???˓???xuʔ??(???z]??K???8U2Q???Rlx?Q?m[n??Bx?o??????w??NjtsL?d?ˬ?Gϊi>?0?lǨX??o? :???????(?	??^?W^?>???,?????Σ??b?|??/>?N/ޮ???rIk???M?Wy>??d?t?T????([?S?0??@?)?8D????.?.??P?1??:?????? ?cl??ݴ?]ǈ؉?

A?xx?S??=b?>b?^dӼ??????+I????ӎ?HM
??'???F	?.???1B??ϣ?G
8????????lgZVE?w?12?ܘ6\?X$?sw???DZ????7G???
?~?U??:?4?:<?eJ	?JK?R??2??M/?@sd?1?٣??
"??l8?;?RI?B???Z)l???&0???Ђ?Ql??%?}????F?r???fŐ28aPM??J??p?a2?R?@??Xݗk?Г?Tb?ҼC?S/s???I?⣯6??gٳ????ͦE??tTɭ??Lq??v'5Pw? ??}&%B?????s???򘥍'	{Pe????????t21I?)DW?	???9a???y????*ᘁ??aǞ??2?????-??U̍p??i??ϋc?????|?Bܦy?-?c?mB6V:?=??@oY?/?@f??M?K??dի?V??6?J???^?(?????t????-ESfR?G??_?|r;z??~??=T?(??jN[!?f6}?c???+?^?zp??٧?it;???ރ??#?x?y??,? 幤?0????(q?A9nq???Ϊ7%??Ѥ????k?й???ƪf??^???u$G??1Sx????&K8?\#?tX?{??m?S??i???
??vXL.??vh?"Z;??) ?7??????Ytu?FZ ??l=ϫ?b???G?LHy?b?g?La??M??5JXd?!(?e?G8?1Z?L4????[?y??`JEŭM]??Nq?٩?N????FI?cO?b??\?itgԋnd[??+?r???h?)彪a?#??yT??~#??@t?68)5BOyZ??S?=ލ?A????7v*??????2??ڹ????[?v??V??^ӂ??Ǝ?iT?d??E???צ?e#n
?kU?nj[??	?$/t4ḏm(7??lu?MP)??,?{>{?G/?p??2??A?`?%I???????d?{???-?Ţr?N+?w?d???-?_?k??&Wg(??@ݱj???z?#Zat~CM?]??w?a????r`ݎ?T;?,/?e?Ӷhh??.F?6WU	????Bwom?m?{_???z?)???QSx????V???qXs?ޏ?5??-?(K4­???<TAcS*???l\??Fm?I?Ri!??>?P?)W??ˊ? ??U{-??q*gu?A????e?G?]??Nk?5?C?51و????dݝM?-[??ʀ????R&?
?6\'????H^????銎OKu؜??&?n???5pwfS;a???1z??^???2?4??i???q>?d-K?v?R.??f3?؊l???1? ;?zEپb$?g??(j?mna?{XN??4l?p S????~????????ߠA?cP??zd?h~il?ǽl??EϳqH0????&???Rl? #?q?y??4_?|?;?|N2v?-#?uzכ?=t?QK?qW?D?MZc??S,v&?Z?½?ڥ?z	?_???3L?&????ϪsjoKM??H7E????J)0(k????KzG??????Q٘??t?W?)I[?5??O?y?xB%=}y?EW'?PL?^B??T14 ??Z?FCR?ZY?HJH?ޛ0ʹMZ??FOz#jm$??*n}ACy? ?7?Jb????+C??+9~?Z??z]???ek????"z^??X?9
?????Q?W?8G??뢋V7
? '$}??-?2譿"?ߛ??_p?i?9???@????m?d??X??5(C?vr}????O?1~?9c?H??e?????o?8r??7	??O?Ԧ?Bs???fM?O?o???B??6Ȫ,z??Z???`G?fBa???? y?? ?c@?L˫?^s???@"?X???bo??쓶-\Qn?5!???㐩?ַ?I?L?P@?;?(?Ф|u%֌0???F=??]̂?j?㇫?m4]-d??X??ʥ?f?ݹ??Y???3???vz???ײf6?)?????J?      ?
   @   x?3?t??I?MT?,LJ?Q?/??4?4202?54?52S02?24?21?3441?0?#????? "?t         ?   x??O?
?0<ǯ?D????\+?f{?"?Z???G??	????a_?,3??b\??6ݢ?u???P"@?????i?i???k3???f^?\ _??ϓ?#(??.	 ??Un?R?Ϊy?oSS??9?ҏwݲ??)
i???*ˏ??+HV!?L$?;??b??q?FQ???(??? x??f(      ?
      x?????? ? ?      ?
      x?????? ? ?      ?
   =   x?3?t??TJ?JTpLJL?4B##C]C#]#3#+C#+#K=K#3|R?\1z\\\ ??3      ?
   .   x?3?4B###]C]C3+cK+c#=3KK<R\1z\\\ ~?      ?
   ?  x?}?Ko?@?5??.?u?\???xk???b!?  PA?_h??c??Y?|ɛ?7?A?r?`????%M???El?N3O-{?=??xq?w??{????????7Sq?(?t???s?lg????#???????3qm?}???x?5?????? ?5?v?	?oXu?\~?j ??fn
?)??	?N?;?N??a?5?C?\x?S????]/s??????M?]L'??X?Ѭ?S?MG?9?C??O?ȓ[?oS? ?ϥs??[B?nA??C2X*c????s??>8(x?
?F?ُ?I????H??vP??O7?!?A?5
OnTx???߲3???%??ۻ????v?}?H?9h??????a?5u?w??S??&??1???@ČJW࿣#???6N??\.R?R?q??rP???Z?I[?e?r?t?o??׺T)??T?j??MPX??B?&<?5
??Υ????????%??s??|???B????02?ݞ飁??????lce?n?
S?T???&_Ż
?????b?0?G????S?*?RH?W^??|?l0?q???Tt?_??.(iQN:??-4Qq???\{[? ????N?Vk/͟?S?q1??u;??2? c?k???2?d(A?H?'U?A~v???????GZ|            x?????? ? ?      ?
      x?????? ? ?     