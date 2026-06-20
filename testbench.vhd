library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ASM is
  port (
    CLK     : in  std_logic;
    Reset   : in  std_logic;                     
    S       : in  std_logic;
    Data    : in  std_logic_vector(19 downto 0);
    Pattern : in  std_logic_vector(3 downto 0);
    Count   : out std_logic_vector(2 downto 0)
  );
end ASM;

architecture BEHAVIOR of ASM is

  type STATE_TYPE is (S0, S1, S2, S3, S4, S5);

  signal CURRENT_STATE, NEXT_STATE : STATE_TYPE;

  signal R : unsigned(19 downto 0) := (others=>'0');
  signal A: std_logic_vector(3 downto 0);
  signal B: std_logic_vector(3 downto 0);
  signal C : unsigned(2 downto 0)  := (others=>'0');
  signal P : integer := 20; --INDEX FLAG

begin

-- PROCESS 1 : STATE REGISTER

process(CLK, Reset)
begin
    if Reset = '0' then
        CURRENT_STATE <= S0;
    elsif ( CLK 'event and CLK = '1') then
        CURRENT_STATE <= NEXT_STATE;
    end if;
end process;

-- PROCESS 2 : NEXT STATE LOGIC

process(CURRENT_STATE, S, A, B, P)
begin
    case CURRENT_STATE is

        when S0 =>
            if S = '1' then
                NEXT_STATE <= S1;
            else
                NEXT_STATE <= S0;
            end if;

        when S1 =>
            NEXT_STATE <= S2;

        when S2 =>
            if A = B then
                NEXT_STATE <= S3;
            else
                NEXT_STATE <= S4;
            end if;

        when S3 =>
            if P <= 4 then
                NEXT_STATE <= S5;
            else
                NEXT_STATE <= S1;
            end if;

        when S4 =>
            if P <= 4 then
                NEXT_STATE <= S5;
            else
                NEXT_STATE <= S1;
            end if;

        when S5 =>
            NEXT_STATE <= S0;

    end case;
end process;

-- PROCESS 3 : SYNCHRONOUS OUTPUTS 

process(CLK, Reset)
begin
    if Reset = '0' then
        R <= (others=>'0');
        A <= (others=>'0');
        B <= (others=>'0');
        C <= (others=>'0');
        P <= 20;
        Count <= (others=>'0');

    elsif ( CLK 'event and CLK = '1') then
        case CURRENT_STATE is

            when S0 =>
                if S = '1' then
                    R <= unsigned(Data);
                    A <= Pattern;
                    B <= (others=>'0');
                    C <= (others=>'0');
                    P <= 20;
                end if;

            when S1 =>
                if P >= 4 then
                    B <= std_logic_vector(R(P-1 downto P-4));
                end if;

            when S2 =>
                null;

            when S3 =>
                if P >= 4 then
                    P <= P - 4;
                    C <= C + 1;
                else
                    P <= 0;
                end if;

            when S4 =>
                if P > 0 then
                    P <= P - 1;
                else
                    P <= 0;
                end if;

            when S5 =>
                Count <= std_logic_vector(C);

        end case;
    end if;
end process;

end architecture BEHAVIOR;
