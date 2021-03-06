Feature: Navigate to editorial board
  In order to make it easier to navigate to our editorial board
  As a reader of the site
  I need easy navigation to the editorial board

  Scenario: About page metadata
    When I go to "/about"
    Then the metatag attribute "description" should have the value "eLife - Open access to the most promising advances in science"

  @javascript @api
  Scenario Outline: First sheet is open
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type |
      | First Name 1              | Last Name 1              | <name>              |
      | First Name 2              | Last Name 2              | Executive Staff     |
    When I go to "/about"
    Then I should see "<name>" in the ".aims-scope__people:not(.off) .aims-scope__people_heading" element

    Examples:
      | name               |
      | Board of Directors |
      | Reviewing Editor   |

  @api
  Scenario: People are ordered
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | sticky |
      | First Name 2              | Last Name 2              | Executive Staff     | 0      |
      | First Name 1              | Last Name 1              | Executive Staff     | 0      |
      | First Name 3              | Last Name 3              | Executive Staff     | 1      |
    When I go to "/about"
    Then I should see "First Name 3" in the ".aims-scope__people li:nth-of-type(1)" element
    Then I should see "First Name 1" in the ".aims-scope__people li:nth-of-type(2)" element
    Then I should see "First Name 2" in the ".aims-scope__people li:nth-of-type(3)" element

  @api
  Scenario: Senior leadership included in senior editors
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise         |
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise | sticky |
      | First Name 2              | Last Name 2              | Senior Editor       | Expertise                | 0      |
      | First Name 1              | Last Name 1              | Senior Editor       | Expertise                | 0      |
      | First Name 3              | Last Name 3              | Senior Editor       | Expertise                | 1      |
      | First Name 4              | Last Name 4              | Deputy Editor       | Expertise                | 0      |
    When I go to "/about"
    Then I should see "First Name 3" in the ".aims-scope__people--expertise li:nth-of-type(1)" element
    Then I should see "First Name 4" in the ".aims-scope__people--expertise li:nth-of-type(2)" element
    Then I should see "First Name 1" in the ".aims-scope__people--expertise li:nth-of-type(3)" element
    Then I should see "First Name 2" in the ".aims-scope__people--expertise li:nth-of-type(4)" element

  @api
  Scenario: Early Careers Advisory Group are excluded
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type          |
      | First Name 1              | Last Name 1              | Early Careers Advisory Group |
    When I go to "/about"
    Then I should not see an ".aims-scope__people" element

  @api
  Scenario: All reviewing editors sheet contains all reviewing editors
    Given "elife_pp_expertise" terms:
      | field_elife_title | weight |
      | Expertise 1       | 2      |
      | Expertise 2       | 1      |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise | field_elife_pp_past |
      | First Name 1              | Last Name 1              | Editor-in-Chief     |                          | No                  |
      | First Name 2              | Last Name 2              | Deputy Editor       |                          | No                  |
      | First Name 3              | Last Name 3              | Senior Editor       | Expertise 1              | No                  |
      | First Name 4              | Last Name 4              | Reviewing Editor    | Expertise 2              | No                  |
      | First Name 5              | Last Name 5              | Senior Editor       | Expertise 1              | Yes                 |
      | First Name 6              | Last Name 6              | Board of Directors  |                          | No                  |
      | First Name 7              | Last Name 7              | Executive Staff     |                          | No                  |
    When I go to "/about"
    Then I should see 7 ".aims-scope__subject_list_item" elements
    And I should see "Editorial leadership" in the ".aims-scope__subject_list_item:nth-child(1)" element
    And I should see "All reviewing editors" in the ".aims-scope__subject_list_item:nth-child(2)" element
    And I should see "Expertise 2" in the ".aims-scope__subject_list_item:nth-child(3)" element
    And I should see "Expertise 1" in the ".aims-scope__subject_list_item:nth-child(4)" element
    And I should see "Past editors" in the ".aims-scope__subject_list_item:nth-child(5)" element
    And I should see "Board of Directors" in the ".aims-scope__subject_list_item:nth-child(6)" element
    And I should see "Executive Staff" in the ".aims-scope__subject_list_item:nth-child(7)" element

  @javascript @api
  Scenario: All reviewing editors sheet contains all reviewing editors
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise 1       |
      | Expertise 2       |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise |
      | Foo                       | Bar                      | Reviewing Editor    | Expertise 2              |
      | Bar                       | Qux                      | Reviewing Editor    | Expertise 1              |
      | Quux                      | Corge                    | Senior Editor       | Expertise 2              |
    When I go to "/about"
    And I click "All reviewing editors"
    Then I should see "All reviewing editors" in the ".aims-scope__people:not(.off) .aims-scope__people_heading" element
    And I should be on "/about#all-reviewing-editors"
    And I should see "Foo Bar"
    And I should see "Bar Qux"
    And I should not see "Quux Corge"

  @javascript @api
  Scenario: Click on sheet (1/2)
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise 1       |
      | Expertise 2       |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise |
      | Foo                       | Bar                      | Reviewing Editor    | Expertise 2              |
      | Bar                       | Qux                      | Reviewing Editor    | Expertise 1              |
      | Quux                      | Corge                    | Senior Editor       | Expertise 2              |
    When I go to "/about"
    And I click "Expertise 1"
    Then I should see "Expertise 1" in the ".aims-scope__people:not(.off) .aims-scope__people_heading" element
    And I should be on "/about#expertise-1"
    And I should see "Bar Qux"
    And I should not see "Foo Bar"
    And I should not see "Quux Corge"

  @javascript @api
  Scenario: Click on sheet (2/2)
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise 1       |
      | Expertise 2       |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise |
      | Foo                       | Bar                      | Reviewing Editor    | Expertise 2              |
      | Bar                       | Qux                      | Reviewing Editor    | Expertise 1              |
      | Quux                      | Corge                    | Senior Editor       | Expertise 2              |
    When I go to "/about"
    And I click "Expertise 2"
    Then I should see "Expertise 2" in the ".aims-scope__people:not(.off) .aims-scope__people_heading" element
    And I should be on "/about#expertise-2"
    And I should see "Foo Bar"
    And I should see "Quux Corge"
    And I should not see "Bar Qux"

  @javascript @api
  Scenario: Past editors sheet
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise 1       |
      | Expertise 2       |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise | field_elife_pp_past |
      | Foo                       | Bar                      | Reviewing Editor    | Expertise 2              | Yes                 |
      | Bar                       | Qux                      | Reviewing Editor    | Expertise 1              | No                  |
      | Quux                      | Corge                    | Senior Editor       | Expertise 2              | Yes                 |
      | Grault                    | Garply                   | Senior Editor       | Expertise 1              | No                  |
    When I go to "/about"
    And I click "Past editors"
    Then I should see "Past editors" in the ".aims-scope__people:not(.off) .aims-scope__people_heading" element
    And I should be on "/about#past-editors"
    And I should see "Foo Bar"
    And I should see "Quux Corge"
    And I should not see "Bar Qux"
    And I should not see "Grault Garply"

  @api
  Scenario: Doesn't add sheets for empty lists
    Given "elife_pp_expertise" terms:
      | field_elife_title |
      | Expertise 1       |
      | Expertise 2       |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_expertise |
      | Foo                       | Bar                      | Reviewing Editor    | Expertise 1              |
    When I go to "/about"
    Then I should see "Expertise 1"
    And I should not see "Expertise 2"
    And I should not see "Executive staff"

  @api
  Scenario: Still displays introduction when no editorial staff
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type |
      | First Name                | Last Name                | Executive Staff     |
    When I go to "/about"
    Then I should see "Aims & scope"
    And I should see "Our Senior editors and Board of Reviewing Editors"

  @api
  Scenario: Counts editorial staff
    Given "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_past |
      | First Name                | Last Name                | Executive Staff     | No                  |
      | First Name                | Last Name                | Executive Staff     | No                  |
      | First Name                | Last Name                | Senior Editor       | No                  |
      | First Name                | Last Name                | Senior Editor       | No                  |
      | First Name                | Last Name                | Senior Editor       | Yes                 |
      | First Name                | Last Name                | Reviewing Editor    | No                  |
      | First Name                | Last Name                | Reviewing Editor    | No                  |
      | First Name                | Last Name                | Reviewing Editor    | No                  |
      | First Name                | Last Name                | Reviewing Editor    | Yes                 |
    When I go to "/about"
    Then I should see "Aims & scope"
    And I should see "Our 2 Senior editors and 3-member Board of Reviewing Editors"

  @api
  Scenario: Reviewing editors show details
    Given "elife_organisation" content:
      | field_elife_o_name | field_elife_o_country |
      | Organisation       | GB                    |
    And "elife_pp_experimental_organism" terms:
      | field_elife_title   |
      | Organism <i>Foo</i> |
    And "elife_pp_expertise" terms:
      | field_elife_title    |
      | Expertise <i>Bar</i> |
    And "elife_pp_research_focus" terms:
      | field_elife_title |
      | Focus <i>Baz</i>  |
    And "elife_person_profile" content:
      | field_elife_pp_first_name | field_elife_pp_last_name | field_elife_pp_type | field_elife_pp_affiliation    | field_elife_pp_organism | field_elife_pp_expertise | field_elife_pp_research_focus |
      | First Name                | Last Name                | Reviewing Editor    | Organisation (United Kingdom) | Organism Foo            | Expertise Bar            | Focus Baz                     |
    When I go to "/about"
    Then I should see "Expertise Bar" in the ".aims-scope__subject_list_item:nth-child(2)" element
    And I should see "Bar" in the ".aims-scope__subject_list_item:nth-child(2) i" element
    And I should see "Expertise Bar" in the "#expertise-bar .aims-scope__people_heading" element
    And I should see "Bar" in the "#expertise-bar .aims-scope__people_heading i" element
    And I should see "First Name Last Name" in the ".person-profile.vcard .fn" element
    And I should see "Organisation (United Kingdom)" in the ".person-profile.vcard .org" element
    And I should see "Organism Foo" in the ".person-profile__list-title:contains('Experimental organism') + ul" element
    And I should see "Foo" in the ".person-profile__list-title:contains('Experimental organism') + ul i" element
    And I should see "Focus Baz" in the ".person-profile__list-title:contains('Research focus') + ul" element
    And I should see "Baz" in the ".person-profile__list-title:contains('Research focus') + ul i" element
