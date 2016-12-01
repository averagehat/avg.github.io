#!/usr/bin/env perl
# Generates index to Universal Features from possibly all alternative names of features and their
# values (listed directly in the source code below). The output must be manually pasted to the
# appropriate place in the file ../_includes/u-feat-table.html.
# Copyright © 2016 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my $source = <<EOF
Abbr: abbreviation
Animacy: animate, inanimate, human, non-human
Aspect: aspect, imperfective aspect, perfective aspect, prospective, progressive, habitual, iterative, frequentative
Case: case, nominative, direct case, accusative, oblique case, absolutive, ergative, dative, genitive, vocative, locative, instrumental, instructive, partitive, distributive case, essive, prolative, translative, factive, comitative, associative, abessive, inessive, illative, elative, additive, adessive, allative, ablative, superessive, sublative, delative, lative, directional allative, temporal, terminative, terminal allative, causative case, motivative, purposive case, benefactive, destinative, comparative case, equative case
Definite: definiteness, indefinite, non-specific indefinite, specific indefinite, definite, construct state, reduced definiteness, complex definiteness
Degree: degree of comparison, positive degree, equative degree, comparative degree, superlative, absolute superlative
Evident: evidentiality, firsthand, non-firsthand, narrative
Foreign: foreign word
Gender: gender, masculine, feminine, neuter, uter, common gender
Mood: mood, modality, indicative, imperative, conditional, potential, subjunctive, conjunctive, jussive, purposive mood, quotative, optative, desiderative, necessitative, admirative
Number: number, singular, plural, dual, trial, paucal, greater paucal, greater plural, inverse number, count plural, counting form, quantitative plural, plurale tantum, collective noun, mass noun, singulare tantum
NumType: numeral type, quantifier, cardinal, ordinal, multiplicative numeral, fraction, set numeral, distributive numeral, range numeral
Person: person, first person, second person, third person, fourth person, zero person
Polarity: polarity, affirmative, positive polarity, negative polarity
Polite: politeness, register, informal, formal, elevated referent, humbled speaker
Poss: possessive
PronType: pronominal type, personal, reciprocal pronominal, article, interrogative, relative, demonstrative, total, collective pronominal, negative pronominal, indefinite pronominal, emphatic, exclamative
Reflex: reflexive
Tense: tense, past, preterite, aorist, present, future, imperfect tense, pluperfect, past perfect
VerbForm: verb form, finite verb, non-finite verb, infinitive, supine, participle, verbal adjective, converb, transgressive, adverbial participle, verbal adverb, gerundive, gerund, verbal noun, masdar
Voice: voice, active, middle voice, passive, antipassive, direct voice, inverse voice, reciprocal voice, causative voice
EOF
;

my @source = split(/\n/, $source);
my %hash;
foreach my $line (@source)
{
    my ($feature, $keywords) = split(/\s*:\s*/, $line);
    my @keywords = split(/\s*,\s*/, $keywords);
    foreach my $keyword (@keywords)
    {
        die("Ambiguous keyword $keyword") if(exists($hash{$keyword}));
        $hash{$keyword} = $feature;
    }
}
my @keys = sort(keys(%hash));
my @index;
my $last_letter = '';
foreach my $key (@keys)
{
    my $letter = uc(substr($key, 0, 1));
    my $feature = $hash{$key};
    my $entry = "<a href=\"$feature.html\">$key</a>";
    $entry = "<strong>$letter</strong>&nbsp;".$entry if($letter ne $last_letter);
    $last_letter = $letter;
    push(@index, $entry);
}
print("<!-- The index was generated from the following source:\n\n$source\n-->\n\n");
print("<strong>Index: </strong>", join(', ', @index), "\n");
